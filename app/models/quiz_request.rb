# == Schema Information
#
# Table name: quiz_requests
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  quiz_number :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class QuizRequest < ActiveRecord::Base
  belongs_to :student
end
