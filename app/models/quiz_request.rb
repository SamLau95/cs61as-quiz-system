# == Schema Information
#
# Table name: quiz_requests
#
#  id         :integer          not null, primary key
#  student_id :integer
#  lesson     :integer
#  created_at :datetime
#  updated_at :datetime
#  approved   :boolean          default(FALSE)
#

# A QuizRequest is created when a student requests a quiz and is destroyed
# after a student starts taking a quiz.
class QuizRequest < ActiveRecord::Base
  belongs_to :student
end
