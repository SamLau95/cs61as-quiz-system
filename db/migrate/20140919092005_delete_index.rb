class DeleteIndex < ActiveRecord::Migration
  def change
    remove_index :quizzes, column: [:lesson, :version]

  end
end
