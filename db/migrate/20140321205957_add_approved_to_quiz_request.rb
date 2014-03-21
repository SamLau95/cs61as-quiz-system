class AddApprovedToQuizRequest < ActiveRecord::Migration
  def change
    add_column :quiz_requests, :approved, :boolean, default: false
  end
end
