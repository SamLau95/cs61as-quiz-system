class AddColumnesToTakenQUizzes < ActiveRecord::Migration
  def change
    remove_column :grades, :retake
    add_column :taken_quizzes, :retake, :boolean, default: false
  end
end
