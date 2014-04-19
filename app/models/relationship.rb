# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  quiz_id     :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Relationship < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :question
end
