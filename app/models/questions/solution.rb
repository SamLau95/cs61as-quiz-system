# == Schema Information
#
# Table name: solutions
#
#  id          :integer          not null, primary key
#  content     :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Solution model
class Solution < ActiveRecord::Base
  belongs_to :question
end
