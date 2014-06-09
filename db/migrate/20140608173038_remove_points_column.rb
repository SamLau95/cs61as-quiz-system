class RemovePointsColumn < ActiveRecord::Migration
  def change
    remove_column :rubrics, :points
  end
end
