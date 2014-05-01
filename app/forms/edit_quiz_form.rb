# Form object for editing quizzes
class EditQuizForm < Reform::Form
  model :quiz

  property :lesson
  property :version
  property :retake
  property :is_draft

  validates :lesson, presence: true, numericality: true
  validates :version, presence: true, numericality: true
  validates :retake, presence: true
  validates :is_draft, presence: true
  validate :points_add_to_10
  validate :check_lessons

  def validate_and_save(quiz_params)
    return false unless validate(quiz_params)
    Quiz.find(id).update_attributes(quiz_params)
  end

  private

  def points_add_to_10
    rlt = @model.relationships
    unless rlt.map { |r| r.points.to_i }.sum == 10
      errors.add :lesson, 'Points must sum to 10'
    end
  end

  def check_lessons
    rlt = @model.relationships
    unless !rlt.empty? || same_lesson(rlt)
      errors.add :lesson, 'Question lessons must match'
    end
  end

  def same_lesson(rlt)
    rlt.each do |r|
      quest = Question.find(r.question_id)
      return false if @model.lesson != quest.lesson
    end
    true
  end

end
