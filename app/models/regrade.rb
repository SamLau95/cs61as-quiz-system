# == Schema Information
#
# Table name: regrades
#
#  id         :integer          not null, primary key
#  student_id :integer
#  quiz_id    :integer
#  graded     :boolean
#  created_at :datetime
#  updated_at :datetime
#  questions  :string(255)
#  reason     :text
#

# Regrade Model
class Regrade < ActiveRecord::Base
  belongs_to :student
  belongs_to :quiz

  validates_presence_of :questions, :reason, :quiz_id, :student_id
end
