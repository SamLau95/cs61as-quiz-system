class MakeLessonAndVersionUnique < ActiveRecord::Migration
  def change
    add_index :quizzes, [:lesson, :version, :retake], unique: true
  end
end
