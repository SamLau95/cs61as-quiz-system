# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  lesson     :string(255)      default("0")
#  version    :integer
#  retake     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  is_draft   :boolean          default(TRUE)
#

# Quiz class; knows its questions and its submisisons
class Quiz < ActiveRecord::Base
  has_many :students, through: :taken_quizzes, foreign_key: 'quiz_id'
  has_many :taken_quizzes
  has_many :questions, through: :relationships, foreign_key: 'question_id'
  has_many :relationships, dependent: :destroy
  has_many :submissions
  has_many :quiz_requests
  has_many :quiz_locks
  has_many :grades

  # TODO: Make sure deleting a question won't screw up quizzes too hard

  scope :drafts,    -> { where is_draft: true }
  scope :published, -> { where is_draft: false }
  scope :invalid, -> { where lesson: "" }

  # validates :lesson, :version, presence: true
  LESSON_VALUES = ["0-1", "0-2", "0-3", "1", "2", "3", "4", "5", "6",
                   "7", "8", "9", "10", "11", "12", "13", "14"]
  LESSON_TITLES = { "0-1" => "Intro",
                    "0-2" => "Intro pt. 2",
                    "0-3" => "Recursion",
                    "1" => "Scheme Basics, Order of Evaluation, Recursion",
                    "2" => "Lambdas and HOF",
                    "3" => "Recursion, Iteration , Efficiency",
                    "4" => "Data Abstraction and Sequences",
                    "5" => "Hierarchical Data",
                    "6" => "Generic Operators",
                    "7" => "OOP",
                    "8" => "Assignment, State and Environment",
                    "9" => "Mutable Data and Vector",
                    "10" => "Streams",
                    "11" => "MCE",
                    "12" => "Lazy & Analyzing Evaluator",
                    "13" => "Logical Programming",
                    "14" => "Concurrency & Mapreduce" }

  DRAFT_LESSON_VALUES = ["0"] + LESSON_VALUES

  def self.lessons
    published.map(&:lesson).uniq.sort_by do |num|
      Quiz::LESSON_VALUES.find_index num
    end.map { |q| "#{q} - #{LESSON_TITLES[q]}" }
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

  def next_number
    questions.size + 1
  end

  def self.generate_random(lesson, rtk)
    quiz = create lesson: lesson, retake: rtk == '1'
    easy, medium, hard = quiz.get_quest(lesson)
    quiz.relationships.create(question: hard, number: quiz.next_number) unless hard.nil?
    quiz.relationships.create(question: medium, number: quiz.next_number) unless medium.nil?
    quiz.relationships.create(question: easy, number: quiz.next_number) unless easy.nil?
    quiz
  end

  def get_quest(lesson)
    questions = []
    ['Easy', 'Medium', 'Hard'].each do |diff|
      qst = Question.where(lesson: lesson, difficulty: diff)
      questions << qst.select { |q| can_add? q }.sample
    end
    questions
  end

  # Updates the number for each question
  def add_numbers
    rlt = Relationship.where quiz_id: id
    count = 1
    rlt.each do |r|
      r.update_attribute :number, count
      count += 1
    end
  end

  def can_add?(question)
    quizzes = Quiz.where lesson: lesson, retake: !retake
    Quiz.check_question quizzes, question
  end

  def self.can_add?(question, les, ret)
    quizzes = Quiz.where lesson: les, retake: !ret
    Quiz.check_question quizzes, question
  end

  def self.check_question(quizzes, question)
    questions_list = []
    quizzes.each { |q| questions_list << q.questions }
    !(questions_list.flatten.include? question)
  end

  def self.has_quiz(lesson, retake)
    !Quiz.published.where(lesson: lesson, retake: retake).blank?
  end

  def self.sort_lesson(quizzes, sortValue)
    quizzes.sort_by do |q|
      [sortValue.find_index(q.lesson), q.version]
    end
  end
end
