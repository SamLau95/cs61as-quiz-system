# == Schema Information
#
# Table name: taken_quizzes
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  student_id :integer
#  created_at :datetime
#  updated_at :datetime
#  grade      :integer          default(0)
#  finished   :boolean          default(FALSE)
#  lesson     :integer
#

# TakenQuiz Class
class TakenQuiz < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :student

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
end
