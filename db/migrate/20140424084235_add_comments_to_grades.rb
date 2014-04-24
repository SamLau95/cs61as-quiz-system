class AddCommentsToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :comments, :text, default: 'No Comments'
  end
end
