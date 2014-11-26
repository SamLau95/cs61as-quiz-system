class ChangingStaffColumn < ActiveRecord::Migration
  def change
    rename_column :taken_quizzes, :staff_id, :reader_id
  end
end
