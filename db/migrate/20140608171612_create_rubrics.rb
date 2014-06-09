class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      t.text :rubric
      t.integer :points
      t.integer :question_id

      t.timestamps
    end

    add_index :rubrics, [:question_id], unique: true
  end
end
