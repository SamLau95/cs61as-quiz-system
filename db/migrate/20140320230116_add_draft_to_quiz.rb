class AddDraftToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :draft, :boolean, default: true
  end
end
