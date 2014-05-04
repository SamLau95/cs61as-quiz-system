class AddDefaultPoints < ActiveRecord::Migration
  def change
    change_column :relationships, :points, :integer, default: 0
  end
end
