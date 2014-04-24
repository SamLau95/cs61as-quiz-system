# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :content
  property :number
  property :lesson
  property :difficulty

  property :solution do
    property :content

    validates :content, presence: true
  end

  validates :content, :lesson, presence: true
  validates :difficulty, presence: true
  validates :lesson, numericality: { greater_than_or_equal_to: 1, 
                                     less_than_or_equal_to: 14}

  def validate_and_save(question_params)
    solution = question_params[:solution_attributes]
    if solution[:content].empty?
      errors.add :content, 'Solution cannot be blank'
    end
    return false unless validate(question_params)
    question = Question.find id
    question.solution.update_attributes solution
    question_params.delete :solution_attributes
    question_params.delete :solution
    question.update_attributes(question_params)
  end
end
