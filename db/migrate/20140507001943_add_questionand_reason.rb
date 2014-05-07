class AddQuestionandReason < ActiveRecord::Migration
  def change
  	add_column :regrades, :questions, :string
  	add_column :regrades, :reason, :text
  end
end
