class QuizLockDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :quiz_locks, :locked, :boolean, default: false
  end
end
