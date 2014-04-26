# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :content
  property :number
  property :points
  property :lesson
  property :difficulty


  validates :content, presence: true
  validates :points, presence: true,
                     numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 10 }
  validates :difficulty, presence: true

  # TODO: Check if this question makes the quiz go over ten points.

  def validate_and_save(question_params)
    return false unless validate(question_params)
    Question.find(id).update_attributes(question_params)
  end
end
