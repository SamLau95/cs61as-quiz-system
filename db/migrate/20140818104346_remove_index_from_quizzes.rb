class RemoveIndexFromQuizzes < ActiveRecord::Migration
  def change
    remove_index :quizzes, column: [:lesson, :version, :retake]
    change_column :quizzes, :version, :integer
    add_index :quizzes, [:lesson, :version], unique: true
  end
end
