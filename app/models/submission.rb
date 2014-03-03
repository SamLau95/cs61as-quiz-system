# == Schema Information
#
# Table name: submissions
#
#  id          :integer          not null, primary key
#  content     :text
#  question_id :integer
#  student_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  quiz_id     :integer
#

class Submission < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :question
  belongs_to :student
end
