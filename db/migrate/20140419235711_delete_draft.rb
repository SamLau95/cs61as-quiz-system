class DeleteDraft < ActiveRecord::Migration
  def change
    remove_column :questions, :draft
  end
end
