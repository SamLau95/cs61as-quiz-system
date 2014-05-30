class CreateTakenQuizzes < ActiveRecord::Migration
  def change
    create_table :taken_quizzes do |t|
      t.integer :quiz_id
      t.integer :student_id
      t.integer :score

      t.timestamps
    end

    add_index :taken_quizzes, [:quiz_id, :student_id], unique: true
  end
end
