# == Schema Information
#
# Table name: grades
#
#  id          :integer          not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  comments    :text             default("No Comments")
#  question_id :integer
#  student_id  :integer
#  grade       :integer
#

class Grade < ActiveRecord::Base
  belongs_to :student
  belongs_to :question
end
