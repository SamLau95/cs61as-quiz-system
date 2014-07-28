# == Schema Information
#
# Table name: taken_quizzes
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  student_id :integer
#  created_at :datetime
#  updated_at :datetime
#  grade      :decimal(, )      default(0.0)
#  finished   :boolean          default(FALSE)
#  lesson     :string(255)      default("")
#  comment    :string(255)      default("No comments")
#  retake     :boolean          default(FALSE)
#  staff_id   :integer
#

# TakenQuiz Class
class TakenQuiz < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :student
  belongs_to :staff
  # Validations for comments

  validates :comment, presence: true, length: { maximum: 200 }

  scope :not_graded, -> { where(finished: false) }

  def to_s
    "#{Student.find student_id}: #{Quiz.find quiz_id}"
  end

  def finish
    update_attribute(:finished, true)
  end

  def undo
    update_attribute(:finished, false)
  end

  def self.sort_quizzes(taken_quizzes)
    taken_quizzes.sort_by do |r|
      q = Quiz.find(r.quiz_id)
      [Quiz.lesson_values[q.lesson], q.version]
    end
  end
end
