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
  # has_many :questions, -> { includes(:options) }, dependent: :destroy
  has_many :questions,  -> { includes(:options) }, through: :relationships
  has_many :relationships, dependent: :destroy
  has_many :submissions
  has_many :quiz_requests
  has_many :quiz_locks

  # TODO: Make sure deleting a question won't screw up quizzes too hard

  scope :drafts,    -> { where is_draft: true }
  scope :published, -> { where is_draft: false }

  def self.lessons
    all.map(&:lesson).uniq.sort
  end

  def self.choose_one(quiz_request)
    published.where(lesson: quiz_request.lesson, retake: quiz_request.retake)
             .sample
  end

  def to_s
    "Quiz #{lesson}#{!retake ? 'a' : 'b'}#{version}#{' (Draft)' if is_draft}"
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

  def self.generate_random(lesson)
    quiz = create
    hard = Question.where(lesson: lesson, difficulty: 'Hard').sample
    medium = Question.where(lesson: lesson, difficulty: 'Medium').sample
    easy = Question.where(lesson: lesson, difficulty: 'Easy').sample
    quiz.relationships.create(question: hard) unless hard.nil?
    quiz.relationships.create(question: medium) unless medium.nil?
    quiz.relationships.create(question: easy) unless easy.nil?
    quiz
  end
end
