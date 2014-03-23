class AddTypeandOptionstoQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :type, :string
    add_column :questions, :options, :string, array: true, default: "{}"
  end
end
