class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.text :content
      t.references :question
      t.timestamps
    end
  end
end
