# Form object for editing quizzes
class EditQuizForm < Reform::Form
  model :quiz

  property :lesson
  property :version
  property :retake
  property :draft

  collection :questions do
    property :id
    property :quiz_id
    property :content
    property :number
    property :points

    validates :quiz_id, presence: true, numericality: true
    validates :content, presence: true
    validates :number, presence: true, numericality: true
    validates :points, presence: true,
                       numericality: { greater_than_or_equal_to: 1,
                                       less_than_or_equal_to: 10 }
  end

  validates :lesson, presence: true, numericality: true
  validates :version, presence: true, numericality: true
  validates :retake, presence: true
  validates :draft, presence: true
  validate :points_add_to_10

  def validate_and_save(quiz_params)
    return false unless validate(quiz_params)
    Quiz.find(id).update_attributes(lesson: lesson, 
                                    version: version,
                                    retake: retake,
                                    draft: draft)
    quiz_params[:questions_attributes].all? do |_, v|
      Question.find(v[:id]).update_attributes v
    end
  end

  private

  def points_add_to_10
    unless questions.map { |q| q.points.to_i }.sum == 10
      errors.add :lesson, 'Points must sum to 10'
    end
  end
end
