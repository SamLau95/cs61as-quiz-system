class AddIndiciesToQuizLocks < ActiveRecord::Migration
  def change
    add_index :quiz_locks, [:student_id, :quiz_id], unique: true
  end
end
