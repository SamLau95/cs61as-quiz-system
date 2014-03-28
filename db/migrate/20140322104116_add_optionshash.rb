class AddOptionshash < ActiveRecord::Migration
  def change
    add_column :questions, :options, :hstore
  end
end
