class AddFirstPasswordtodb < ActiveRecord::Migration
  def change
    add_column :users, :first_password, :string, default: ""
  end
end
