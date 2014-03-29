class CreateQuizLocks < ActiveRecord::Migration
  def change
    create_table :quiz_locks do |t|
      t.references :student
      t.references :quiz
      t.boolean :locked

      t.timestamps
    end
  end
end
