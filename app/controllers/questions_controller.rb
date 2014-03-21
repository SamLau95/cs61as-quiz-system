
# Destroys question
class QuestionsController < ApplicationController
  load_and_authorize_resource

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:success] = 'Deletion successful'
    redirect_to edit_quiz_path(@question.quiz_id)
  end
end
