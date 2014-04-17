class AddLessonToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :lesson, :integer
  end
end
