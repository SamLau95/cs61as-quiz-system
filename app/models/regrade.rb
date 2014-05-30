# == Schema Information
#
# Table name: regrades
#
#  id         :integer          not null, primary key
#  student_id :integer
#  quiz_id    :integer
#  graded     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  questions  :string(255)
#  reason     :text
#

# Regrade Model
class Regrade < ActiveRecord::Base
  belongs_to :student
  belongs_to :quiz

  scope :not_graded, -> { where(graded: false) }

  validates_presence_of :questions, :reason, :quiz_id, :student_id

  def to_s
    quiz = Quiz.find quiz_id
    student = Student.find student_id
    "#{student} - #{quiz}"
  end
end
