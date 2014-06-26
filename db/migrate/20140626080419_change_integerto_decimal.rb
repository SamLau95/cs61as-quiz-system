class ChangeIntegertoDecimal < ActiveRecord::Migration
  def change
    change_column :grades, :grade, :decimal, precision: 2, scale: 1
    change_column :taken_quizzes, :grade, :decimal, precision: 3, scale: 1
  end
end
