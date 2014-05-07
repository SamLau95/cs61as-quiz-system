class AddDefaultToRegrade < ActiveRecord::Migration
  def change
    change_column :regrades, :graded, :boolean, default: false
  end
end
