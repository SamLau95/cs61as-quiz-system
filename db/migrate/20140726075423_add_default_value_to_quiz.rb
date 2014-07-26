class AddDefaultValueToQuiz < ActiveRecord::Migration
  def change
    change_column :quizzes, :version, :integer, default: 0 
  end
end
