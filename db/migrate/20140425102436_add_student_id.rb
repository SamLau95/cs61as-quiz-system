class AddStudentId < ActiveRecord::Migration
  def change
    add_column :users, :login, :string, default: ""
  end
end
