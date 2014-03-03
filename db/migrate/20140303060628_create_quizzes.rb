class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :lesson
      t.integer :version
      t.boolean :retake, default: false

      t.timestamps
    end
  end
end
