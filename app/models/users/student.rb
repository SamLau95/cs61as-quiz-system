require 'csv'
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  type                   :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  login                  :string(255)      default("")
#  added_info             :boolean          default(FALSE)
#  first_password         :string(255)      default("")
#

# Student model; uses users table
class Student < User
  default_scope -> { order 'last_name' }

  has_many :quizzes, through: :taken_quizzes, foreign_key: 'student_id'
  has_many :taken_quizzes, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_one :quiz_request, dependent: :destroy
  has_one :quiz_lock, dependent: :destroy
  has_many :grades, dependent: :destroy
  has_many :regrades, dependent: :destroy

  delegate :lesson, to: :quiz_request, prefix: true
  delegate :locked?, to: :quiz_lock, allow_nil: true

  scope :valid_students, -> { where(added_info: true) }

  def email_required?
    false
  end

  def approved_request?
    quiz_lock && !quiz_lock.locked
  end

  def making_request?
    quiz_request
  end

  def taking_quiz?
    quiz_lock
  end

  def student?
    true
  end

  def name
    "#{first_name} #{last_name}"
  end

  def to_s
    "#{name}: #{login}"
  end

  def retake(lesson)
    subm = Submission.where(student_id: id)
    take = []
    subm.each do |s|
      q = Quiz.find(s.quiz_id)
      take << q if q.lesson == lesson
    end
    take.uniq.size
  end

  def self.get_csv(lesson)
    students = TakenQuiz.where(lesson:lesson).map { |t| t.student }.uniq
    CSV.generate do |csv|
      csv << ["Lesson #{lesson} grades"]
      csv << ['Login', 'Grade', 'Comments', 'Retake?']
      students.each do |student|
        if student.has_grade(lesson)
          csv << student.get_row(lesson)
        end
      end
    end
  end

  def has_grade(lesson)
    !grades.where(lesson: lesson).blank? &&
    taken_quizzes.where(lesson: lesson).inject(true) do |a, b|
      a && b.finished
    end
  end

  def get_row(lesson)
    quiz1 = TakenQuiz.find_by student_id: id, lesson: lesson, retake: false
    quiz2 = TakenQuiz.find_by student_id: id, lesson: lesson, retake: true
    if quiz2.blank?
      return [login, quiz1.grade, quiz1.comment, false]
    else
      grade = quiz2.grade == 10 ? 9 : quiz2.grade
      return [login, grade, quiz2.comment, true]
    end
  end

  def self.get(search)
    return nil if search.blank? || Student.all.blank?
    search = search.downcase
    Student.valid_students.select do |s|
      s.first_name.downcase.include?(search) ||
      s.last_name.downcase.include?(search) ||
      s.to_s.downcase.include?(search) ||
      s.login.downcase.include?(search)
    end
  end

  def check_if_send_email
    quizzes = taken_quizzes.graded.first(3)
    StaffMailer.help_email(self,quizzes).deliver
    # HelpEmailJob.new.async.perform(self, quizzes) if is_failing?(quizzes)
  end

  def is_failing?(quizzes)
    quizzes.select { |q| q.grade <= 6 }.size == 3
  end

  def self.reset
    ResetStudentJob.new.async.perform
  end
end
