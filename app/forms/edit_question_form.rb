# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :content
  property :lesson
  property :difficulty

  property :solution do
    property :content
    validates :content, presence: true
  end

  property :rubric do
    property :rubric
    validates :rubric, presence: true
  end

  validates :content, :lesson, presence: true
  validates :difficulty, presence: true
  validates :lesson, numericality: { greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 14 }
  validate :check_solution
  validate :check_rubric

  def validate_and_save(question_params)
    question = Question.find id
    question.solution.update_attributes question_params[:solution_attributes]
    question.rubric.update_attributes question_params[:rubric_attributes]
    question_params = update_points(question_params)
    return false unless validate(question_params)
    question_params.delete :solution_attributes
    question_params.delete :solution
    question_params.delete :rubric
    question_params.delete :rubric_attributes
    question.update_attributes(question_params)
  end

  def check_solution
    if @fields.solution.content.blank?
      errors.add :content, "Doesn't have solution."
    end
  end

  def check_rubric
    if @fields.rubric.rubric.blank?
      errors.add :content, 'Needs a Rubric'
    end
  end

  def update_points(params)
    unless params[:points][:pts].blank? || params[:points][:qid].blank?
      rlt = Relationship.find_by quiz_id: params[:points][:qid],
                                 question_id: id
      rlt.update_attribute(:points, params[:points][:pts])
    end
    params.delete :points
    params
  end
end
