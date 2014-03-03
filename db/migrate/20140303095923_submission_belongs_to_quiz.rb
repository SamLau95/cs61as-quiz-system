class SubmissionBelongsToQuiz < ActiveRecord::Migration
  def change
    add_reference :submissions, :quiz, index: true
  end
end
