class AddLesson < ActiveRecord::Migration
  def change
    add_column :taken_quizzes, :lesson, :integer
  end
end
