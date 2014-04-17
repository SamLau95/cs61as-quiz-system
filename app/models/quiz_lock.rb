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

  validates :student_id, :quiz_id, presence: true

  def time_left
    [expire_time - Time.now, 0].max.to_i
  end

  def expire_time
    created_at + 1.hour
  end

  def lock!
    self.locked = true
    save!
  end
end
