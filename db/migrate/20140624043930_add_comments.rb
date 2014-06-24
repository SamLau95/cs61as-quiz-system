class AddComments < ActiveRecord::Migration
  def change
    add_column :taken_quizzes, :comment, :string, default: 'No comments'
  end
end
