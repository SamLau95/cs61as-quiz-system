class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :text
      t.belongs_to :question
      t.belongs_to :student

      t.timestamps
    end
  end
end
