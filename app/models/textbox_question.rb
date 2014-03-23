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

# TextBox Question
class TextboxQuestion < Question
  def self.title
    'Short Answer'
  end

  def self.param
    'textbox'
  end
end
