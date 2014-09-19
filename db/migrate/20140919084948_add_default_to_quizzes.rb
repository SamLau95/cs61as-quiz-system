class AddDefaultToQuizzes < ActiveRecord::Migration
  def change
    change_column :quizzes, :lesson, :string, default: "0"
  end
end
