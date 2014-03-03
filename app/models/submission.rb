# == Schema Information
#
# Table name: submissions
#
#  id          :integer          not null, primary key
#  text        :text
#  question_id :integer
#  student_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Submission < ActiveRecord::Base
end
