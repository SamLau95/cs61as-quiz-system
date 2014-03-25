
# Question Controller
class QuestionsController < ApplicationController
  load_and_authorize_resource

  def new
    @quiz = Quiz.find params[:id]
    @question = @quiz.questions.create type: params[:format]
    redirect_to edit_question_path(@question)
  end

  def edit
    question = Question.find params[:id]
    question.options.create if params[:add]
    @quest_form = EditQuestionForm.new question
    respond_to do |format|
      format.html { render 'edit' }
      format.js {}
    end
  end

  def update
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:success] = 'Deletion successful'
    redirect_to edit_quiz_path(@question.quiz_id)
  end
end
