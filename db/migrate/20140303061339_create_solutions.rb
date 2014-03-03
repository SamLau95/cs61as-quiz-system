class CreateSolutions < ActiveRecord::Migration
  def change
    create_table :solutions do |t|
      t.text :text
      t.belongs_to :question
      
      t.timestamps
    end
  end
end
