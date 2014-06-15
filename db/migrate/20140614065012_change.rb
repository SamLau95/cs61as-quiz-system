class Change < ActiveRecord::Migration
  def change
    change_column :grades, :lesson, :string, default: ''
    change_column :quizzes, :lesson, :string, default: ''
    change_column :questions, :lesson, :string, default: ''
    change_column :quiz_requests, :lesson, :string, default: ''
    change_column :taken_quizzes, :lesson, :string, default: ''
  end
end
