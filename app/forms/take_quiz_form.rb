# Form object for submissions
class TakeQuizForm < Reform::Form
  model :quiz

  property :lesson, virtual: true

  collection :new_submissions do
    property :question_content, virtual: true

    property :quiz_id
    property :question_id
    property :student_id
    property :content

    validates :quiz_id, :question_id, :student_id, presence: true
    validates :content, presence: true
  end

  def validate_and_save(params)
    return false unless validate(params)
    params[:new_submissions_attributes].none? do |_, attrs|
      Submission.create(attrs).new_record?
    end
  end
end
