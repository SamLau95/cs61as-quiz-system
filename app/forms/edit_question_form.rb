# Edit question here
class EditQuestionForm < Reform::Form
  model :question

  property :id
  property :quiz_id
  property :content
  property :number
  property :points
  property :format

  validates :format, presence: true
  validates :quiz_id, presence: true, numericality: true
  validates :content, presence: true
  validates :number, presence: true, numericality: true
  validates :points, presence: true,
                     numericality: { greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 10 }
end
