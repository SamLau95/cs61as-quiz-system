class CreateQuizRequests < ActiveRecord::Migration
  def change
    create_table :quiz_requests do |t|
      t.references :user, index: true
      t.references :quiz, index: true

      t.timestamps
    end
  end
end
