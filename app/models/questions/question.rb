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
#  lesson     :integer
#  difficulty :string(255)
#

# Model that represents questions
class Question < ActiveRecord::Base
  default_scope -> { order 'number ASC' }

  has_many :relationships, dependent: :destroy
  has_many :quizzes, through: :relationships

  has_many :submissions
  has_one :solution, dependent: :destroy


  def to_s
    "Question #{number} (#{points} points)"
  end

  def self.levels
    [%w(Easy Easy), %w(Medium Medium), %w(Hard Hard)]
  end
end
