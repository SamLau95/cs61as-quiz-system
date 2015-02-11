# == Schema Information
#
# Table name: quiz_locks
#
#  id         :integer          not null, primary key
#  student_id :integer
#  quiz_id    :integer
#  locked     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  quiz_time  :integer          default(60)
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
    created_at + quiz_time.minutes
  end

  def lock!
    self.locked = true
    save!
  end

  def unlock!
    self.locked = false
    save!
  end
end
