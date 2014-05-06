class AddLessonToGrade < ActiveRecord::Migration
  def change
    add_column :grades, :lesson, :integer
  end
end
