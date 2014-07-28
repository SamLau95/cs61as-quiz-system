class AddStaffToTakenQuizzes < ActiveRecord::Migration
  def change
    add_column :taken_quizzes, :staff_id, :integer
    add_index :taken_quizzes, :staff_id
  end
end
