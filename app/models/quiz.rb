# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  lesson     :integer
#  version    :integer
#  retake     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Quiz < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :submissions
  has_many :quiz_requests

  accepts_nested_attributes_for :submissions

  def full_name
    "Quiz #{lesson}#{!retake ? 'a' : 'b'}#{version}"
  end
end
