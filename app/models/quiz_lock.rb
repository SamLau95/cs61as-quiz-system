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

class QuizLock < ActiveRecord::Base
end
