class AddDraftToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :draft, :boolean, default: true
  end
end
