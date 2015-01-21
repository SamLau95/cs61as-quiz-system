class AddReaderLogin < ActiveRecord::Migration
  def change
    add_column :taken_quizzes, :login, :string, default: ""
  end
end
