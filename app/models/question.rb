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
#  points     :integer          not null
#

class Question < ActiveRecord::Base
  belongs_to :quiz
  has_many :submissions
  has_one :solution, dependent: :destroy

  def full_name
    "Question #{number} (#{points} points)"
  end
end
