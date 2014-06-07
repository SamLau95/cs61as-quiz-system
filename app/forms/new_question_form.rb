# Edit question here
class NewQuestionForm < Reform::Form
  model :question

  property :id
  property :content
  property :lesson
  property :difficulty

  property :solution do
    property :content

    validates :content, presence: true
  end

  validates :content, :lesson, presence: true
  validates :difficulty, presence: true
  validates :lesson, numericality: { greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 14 }
  validate :check_solution

  def validate_and_save(question_params)
    return false unless validate(question_params)
    pts = question_params.delete :points
    @model.save
    @model.solution.update_attribute(:question_id, @model.id)
    update_points(pts)
  end

  def check_solution
    if @model.solution.content.blank?
      errors.add :content, "Doesn't have solution."
    end
  end

  def update_points(pts)
    unless pts[:qid].blank?
      rlt = Relationship.create quiz_id: pts[:qid],
                                question_id: @model.id,
                                points: pts[:pts] || 0
    end
    true
  end
end
