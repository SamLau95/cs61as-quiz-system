# Form object for editing quizzes
class EditQuizForm < Reform::Form
  property :lesson
  property :version
  property :retake

  collection :questions do
    property :quiz_id
    property :content

    validates :quiz_id, true
    validates :content, presence: true
  end

  def save(params)
    return false unless validate(params)
    params[:new_submissions_attributes].all? do |_, attrs|
      Submission.create attrs
    end
  end
end
