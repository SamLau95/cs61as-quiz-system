
# Question Controller
class QuestionsController < ApplicationController
  load_and_authorize_resource

  def create
    Question.create
    @quiz_form = EditQuizForm.new Quiz.find(params[:id])
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:success] = 'Deletion successful'
    redirect_to edit_quiz_path(@question.quiz_id)
  end
end
