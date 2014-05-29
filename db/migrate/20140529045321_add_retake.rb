class AddRetake < ActiveRecord::Migration
  def change
    add_column :grades, :retake, :boolean, default: false
  end
end
