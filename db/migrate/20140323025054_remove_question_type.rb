class RemoveQuestionType < ActiveRecord::Migration
  def change
    drop_table :question_types
  end
end
