class AddMinutesToQuizLock < ActiveRecord::Migration
  def change
    add_column :quiz_locks, :quiz_time, :integer, default: 60
  end
end
