class AddRelationshipTable < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :quiz_id
      t.integer :question_id

      t.timestamps
    end

    add_index :relationships, :question_id
    add_index :relationships, :quiz_id
    add_index :relationships, [:question_id, :quiz_id], unique: true
  end
end
