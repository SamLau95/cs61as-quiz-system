require 'csv'

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
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
#  first_name             :text
#  last_name              :text
#  login                  :string(255)      default("")
#

# Student model; uses users table
class Student < User
  default_scope -> { order 'last_name' }

  has_many :submissions
  has_one :quiz_request
  has_one :quiz_lock
  has_many :grades
  has_many :regrades

  delegate :lesson, to: :quiz_request, prefix: true
  delegate :locked?, to: :quiz_lock, allow_nil: true

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

  def to_s
    "#{first_name} #{last_name}"
  end

  def taken_quizzes
    taken = []
    submissions.each { |sub| taken << Quiz.find(sub.quiz_id) }
    taken.uniq.sort_by(&:lesson)
  end

  def retake(lesson)
    subm = Submission.where(student_id: id)
    take = []
    subm.each do |s|
      q = Quiz.find(s.quiz_id)
      take << q if q.lesson == lesson.to_i
    end
    take.uniq.size
  end

  def self.get_csv(lesson)
    CSV.generate do |csv|
      csv << ['Login', 'Grade']
      all.each do |student|
        if student.has_grade(lesson)
          csv << [student.login, student.get_max(lesson)]
        end
      end
    end
  end

  def has_grade(lesson)
    !grades.where(lesson: lesson).blank?
  end

  def get_max(lesson)
    grades1 = grades.where(lesson: lesson, retake: 'false')
    grades2 = grades.where(lesson: lesson, retake: 'true')
    total1, total2 = 0, 0
    if grades2.blank?
      grades1.each { |g| total1 += g.grade }
      return grade1
    else
      grades2.each { |g| total2 += g.grade }
      return grade2
    end
  end
end
