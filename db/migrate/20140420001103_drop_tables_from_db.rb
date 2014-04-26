class DropTablesFromDb < ActiveRecord::Migration
  def change
    drop_table :options
  end
end
