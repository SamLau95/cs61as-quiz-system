class RemoveGradeColumns < ActiveRecord::Migration
  def change
    remove_column :grades, :integer
    remove_column :grades, :question_id
    remove_column :grades, :student_id
    remove_column :grades, :grade
    add_column :grades, :question_id, :integer
    add_column :grades, :student_id, :integer
    add_column :grades, :grade, :integer
  end
end
