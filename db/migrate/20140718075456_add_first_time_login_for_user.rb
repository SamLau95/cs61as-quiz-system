class AddFirstTimeLoginForUser < ActiveRecord::Migration
  def change
    add_column :users, :added_info, :boolean, default: false
  end
end
