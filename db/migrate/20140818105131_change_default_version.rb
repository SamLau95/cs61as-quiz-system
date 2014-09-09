class ChangeDefaultVersion < ActiveRecord::Migration
  def change
    change_column :quizzes, :version, :integer, default: nil
  end
end
