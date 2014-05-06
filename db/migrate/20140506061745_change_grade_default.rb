class ChangeGradeDefault < ActiveRecord::Migration
  def change
    change_column :grades, :grade, :integer, default: 0
  end
end
