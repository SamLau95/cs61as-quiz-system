# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :quiz_id
  property :content
  property :number
  property :points
  property :type

  collection :options do

    property :content
    property :question_id

    validates :content, presence: true
    validates :question_id, presence: true

  end

  validates :quiz_id, presence: true, numericality: true
  validates :content, presence: true
  validates :number, presence: true, numericality: true
  validates :points, presence: true,
                     numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 10 }
  validates :type, presence: true
  # TODO: Check if this question makes the quiz go over ten points.
end
