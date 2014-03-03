class ChangeTextToContent < ActiveRecord::Migration
  def change
    rename_column :questions, :text, :content
    rename_column :solutions, :text, :content
    rename_column :submissions, :text, :content
  end
end
