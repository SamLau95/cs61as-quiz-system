class RenameUserToStudentQuizToNumber < ActiveRecord::Migration
  def change
    rename_column :quiz_requests, :user_id, :student_id
    rename_column :quiz_requests, :quiz_id, :quiz_number
    remove_index :quiz_requests, :quiz_number
  end
end
