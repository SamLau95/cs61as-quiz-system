class ChangeDraftName < ActiveRecord::Migration
  def change
    change_column :questions, :points, :integer, default: 0
    rename_column :quizzes, :draft, :is_draft  
  end
end
