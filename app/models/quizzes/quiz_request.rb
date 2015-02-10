# == Schema Information
#
# Table name: quiz_requests
#
#  id         :integer          not null, primary key
#  student_id :integer
#  lesson     :string(255)      default("")
#  created_at :datetime
#  updated_at :datetime
#  approved   :boolean          default(FALSE)
#  retake     :boolean          default(FALSE)
#

# A QuizRequest is created when a student requests a quiz and is destroyed
# after a student starts taking a quiz.
class QuizRequest < ActiveRecord::Base
  belongs_to :student

  def lock_and_destroy!(quiz, time)
    quiz = Quiz.choose_one(self).id if quiz.blank?
    QuizLock.create! student_id: student.id, quiz_id: quiz, quiz_time: time
    destroy
  end

  def to_s
    "#{student}: Quiz #{lesson}#{", Approved" if approved}"
  end
end
