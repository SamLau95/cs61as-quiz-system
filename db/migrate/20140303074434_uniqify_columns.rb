class UniqifyColumns < ActiveRecord::Migration
  def change
    add_index :questions, [:number, :quiz_id], unique: true
    add_index :solutions, :question_id, unique: true
    add_index :submissions, [:question_id, :student_id], unique: true
  end
end
