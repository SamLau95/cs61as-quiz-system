# == Schema Information
#
# Table name: quiz_requests
#
#  id         :integer          not null, primary key
#  student_id :integer
#  lesson     :integer
#  created_at :datetime
#  updated_at :datetime
#  approved   :boolean          default(FALSE)
#  retake     :boolean          default(FALSE)
#

# A QuizRequest is created when a student requests a quiz and is destroyed
# after a student starts taking a quiz.
class QuizRequest < ActiveRecord::Base
  belongs_to :student

  scope :not_approved, -> { where approved: false }

  def approve_and_lock!
    self.approved = true
    save!
    QuizLock.create! student: student, quiz: Quiz.choose_one(self)
  end

  def to_s
    "#{student}: Quiz #{lesson}#{", Approved" if approved}"
  end
end
