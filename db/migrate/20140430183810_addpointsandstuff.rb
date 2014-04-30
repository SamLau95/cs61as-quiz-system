class Addpointsandstuff < ActiveRecord::Migration
  def change
    add_column :relationships, :points, :integer
    add_column :relationships, :number, :integer
    remove_column :questions, :number
    remove_column :questions, :points
  end
end
