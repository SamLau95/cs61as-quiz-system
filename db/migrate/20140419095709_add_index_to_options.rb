class AddIndexToOptions < ActiveRecord::Migration
  def change
    add_index :options, :question_id
  end
end
