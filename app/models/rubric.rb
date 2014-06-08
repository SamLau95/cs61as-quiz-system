# == Schema Information
#
# Table name: rubrics
#
#  id          :integer          not null, primary key
#  rubric      :text
#  points      :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Rubric < ActiveRecord::Base
  belongs_to :question
end
