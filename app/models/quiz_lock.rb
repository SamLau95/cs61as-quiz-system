# == Schema Information
#
# Table name: quiz_locks
#
#  id         :integer          not null, primary key
#  student_id :integer
#  quiz_id    :integer
#  locked     :boolean
#  created_at :datetime
#  updated_at :datetime
#

# Created when a quiz request is approved; locks a student to a particular quiz
class QuizLock < ActiveRecord::Base
  belongs_to :student
  belongs_to :quiz
end
