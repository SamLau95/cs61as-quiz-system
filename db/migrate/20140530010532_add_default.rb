class AddDefault < ActiveRecord::Migration
  def change
    add_column :taken_quizzes, :grade, :integer, default: 0
    remove_column :taken_quizzes, :score
  end
end
