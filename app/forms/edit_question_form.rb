# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :content
  # property :number
  property :lesson
  property :difficulty

  property :solution do
    property :content

    validates :content, presence: true
  end

  validates :content, :lesson, presence: true
  validates :difficulty, presence: true
  validates :lesson, numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 14 }
  validate :check_solution

  def validate_and_save(question_params)
    1/0
    solution = question_params[:solution_attributes]
    question = Question.find id
    question.solution.update_attributes solution
    return false unless validate(question_params)
    question_params.delete :solution_attributes
    question_params.delete :solution
    question.update_attributes(question_params)
  end

  def check_solution
    unless !@model.solution.content.blank?
      errors.add :content, "Doesn't have solution."
    end
  end
end
