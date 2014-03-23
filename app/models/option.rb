# == Schema Information
#
# Table name: options
#
#  id          :integer          not null, primary key
#  content     :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Option < ActiveRecord::Base
  belongs_to :question
end
