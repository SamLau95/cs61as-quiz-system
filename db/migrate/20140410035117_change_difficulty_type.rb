class ChangeDifficultyType < ActiveRecord::Migration
  def change
    change_column :questions, :difficulty, :string
  end
end
