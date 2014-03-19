# Form object for editing quizzes
class EditQuizForm < Reform::Form
  model :quiz

  property :lesson
  property :version
  property :retake

  collection :questions do
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
  validates :version, presence: true
  validates :retake, presence: true
  validate :points_add_to_10

  private

  def points_add_to_10
    unless questions.map { |q| q.points.to_i }.sum == 10
      errors.add :lesson, 'Points must sum to 10'
    end
  end
end
