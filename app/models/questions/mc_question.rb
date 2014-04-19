# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  number     :integer
#  created_at :datetime
#  updated_at :datetime
#  points     :integer          default(0), not null
#  type       :string(255)
#  lesson     :integer
#  difficulty :string(255)
#

# Multiple Choice questiion
class MCQuestion < Question
  def self.title
    'Multiple Choice'
  end

  def self.param
    'MCQuestion'
  end
end
