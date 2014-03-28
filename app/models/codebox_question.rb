# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  number     :integer
#  quiz_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  points     :integer          default(0), not null
#  type       :string(255)
#

# Code box question
class CodeboxQuestion < Question
  def self.title
    'Coding Question'
  end

  def self.param
    'CodeboxQuestion'
  end
end
