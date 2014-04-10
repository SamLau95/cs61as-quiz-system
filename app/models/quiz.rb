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
#  is_draft   :boolean          default(TRUE)
#

# Quiz class; knows its questions and its submisisons
class Quiz < ActiveRecord::Base
  has_many :questions, -> { includes(:options) }, dependent: :destroy
  has_many :submissions
  has_many :quiz_requests

  scope :drafts,    -> { where is_draft: true }
  scope :published, -> { where is_draft: false }

  def self.lessons
    all.map(&:lesson).uniq.sort
  end

  def self.choose_one(quiz_request)
    where(lesson: quiz_request.lesson, retake: quiz_request.retake).sample
  end

  def to_s
    "Quiz #{lesson}#{!retake ? 'a' : 'b'}#{version}"
  end

  def new_submissions
    questions.map { |q| submissions.build question: q }
  end

  def self.all_lessons
    (1..14).to_a
  end

  def next_number
    return 1 unless !questions.empty?
    questions.last.number + 1
  end
end
