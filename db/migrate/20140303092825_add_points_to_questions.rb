class AddPointsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :points, :integer, null: false
  end
end
