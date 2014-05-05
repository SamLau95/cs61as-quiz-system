# Edit Grades Here
class EditGradeForm < Reform::Form
  model :grade

  property :grade
  property :comments
  property :question_id
  property :student_id
  property :lesson

  validates_presence_of :grade, :comments
  validate :check_points

  def validate_and_save(grade_params)
    return false unless validate(grade_params)
    Grade.find(id).update_attributes(grade_params)
  end

  def check_points
    unless (1..10).include? @fields.grade.to_i
      errors.add :grade, 'Invalid grade'
    end
  end
end
