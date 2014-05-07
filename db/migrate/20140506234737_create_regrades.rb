class CreateRegrades < ActiveRecord::Migration
  def change
    create_table :regrades do |t|
      t.integer :student_id
      t.integer :quiz_id
      t.boolean :graded

      t.timestamps
    end
    add_index :regrades, :quiz_id
    add_index :regrades, :student_id
  end
end
