class RenameQuizNumberToLesson < ActiveRecord::Migration
  def change
    rename_column :quiz_requests, :quiz_number, :lesson
  end
end
