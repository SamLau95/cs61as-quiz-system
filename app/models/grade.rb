# == Schema Information
#
# Table name: grades
#
#  id          :integer          not null, primary key
#  question_id :string(255)
#  integer     :string(255)
#  student_id  :string(255)
#  grade       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  comments    :text             default("No Comments")
#

class Grade < ActiveRecord::Base
end
