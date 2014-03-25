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

  def validate_and_save(quiz_params)
    return false unless validate(quiz_params)
    Quiz.find(id).update_attributes(lesson: lesson,
                                    version: version,
                                    retake: retake,
                                    is_draft: is_draft)
  end

  # TODO: check points when making questions

  private

  def points_add_to_10
    unless questions.map { |q| q.points.to_i }.sum == 10
      errors.add :lesson, 'Points must sum to 10'
    end
  end
end
