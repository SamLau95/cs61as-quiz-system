class ChangeIntegertoDecimal < ActiveRecord::Migration
  def change
    change_column :grades, :grade, :decimal
    change_column :taken_quizzes, :grade, :decimal
  end
end
