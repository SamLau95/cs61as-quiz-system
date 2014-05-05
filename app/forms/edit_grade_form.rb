# Edit Grades Here
class EditGradeForm < Reform::Form
  model :grade

  property :grade
  property :comments
  property :question_id
  property :student_id
  property :lesson

  validates_presence_of :grade, :comments
end
