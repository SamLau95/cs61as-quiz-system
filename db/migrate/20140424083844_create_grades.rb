class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :question_id
      t.string :integer
      t.string :student_id
      t.string :integer
      t.string :grade
      t.string :integer

      t.timestamps
    end

    add_index :grades, :question_id
    add_index :grades, :student_id
  end
end
