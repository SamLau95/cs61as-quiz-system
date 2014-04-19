# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :content
  property :number
  property :points
  property :type
  property :lesson
  property :difficulty

  collection :options do

    property :content
    property :question_id

    validates :content, presence: true
    validates :question_id, presence: true

    # TODO: Check if question lesson matches quiz lesson

  end

  validates :content, presence: true
  validates :points, presence: true,
                     numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 10 }
  validates :type, presence: true
  validates :difficulty, presence: true

  # TODO: Check if this question makes the quiz go over ten points.

  def validate_and_save(question_params)
    return false unless validate(question_params)
    if question_params[:options_attributes]
      question_params[:options_attributes].all? do |_, v|
        Option.find(v[:id]).update_attributes v
      end
    end
    question_params.delete :options
    question_params.delete :options_attributes
    Question.find(id).update_attributes(question_params)
  end
end
