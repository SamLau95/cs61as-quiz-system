class AddGradedToRelationship < ActiveRecord::Migration
  def change
    add_column :taken_quizzes, :finished, :boolean, default: false
  end
end
