# == Schema Information
#
# Table name: question_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Different types of questions - checkbox, radiobutton, etc
class QuestionType < ActiveRecord::Base
  has_many :types
end
