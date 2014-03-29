class AddRetakeToQuizRequests < ActiveRecord::Migration
  def change
    add_column :quiz_requests, :retake, :boolean, default: false
  end
end
