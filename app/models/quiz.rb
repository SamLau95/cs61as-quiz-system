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

# Quiz class; knows its questions and its submisisons
class Quiz < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :submissions
  has_many :quiz_requests

  scope :drafts,    -> { where draft: true }
  scope :published, -> { where draft: false }
  
  def full_name
    "Quiz #{lesson}#{!retake ? 'a' : 'b'}#{version}"
  end

  def new_submissions
    questions.map { |q| submissions.build question: q }
  end

  def self.create_with_question
    quiz = create
    quiz.questions.create points: 0
    quiz
  end
end
