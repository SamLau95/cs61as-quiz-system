# == Schema Information
#
# Table name: solutions
#
#  id          :integer          not null, primary key
#  text        :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Solution < ActiveRecord::Base
  belongs_to :question
end
