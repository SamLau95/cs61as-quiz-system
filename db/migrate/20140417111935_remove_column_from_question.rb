class RemoveColumnFromQuestion < ActiveRecord::Migration
  def change
    remove_column :questions, :quiz_id
  end
end
