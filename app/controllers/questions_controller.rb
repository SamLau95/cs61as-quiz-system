# Question Controller
class QuestionsController < ApplicationController
  load_and_authorize_resource

  def new
    if params[:id]
      @quiz = Quiz.find params[:id]
      @question = @quiz.questions.create type: params[:format],
                                         lesson: @quiz.lesson,
                                         number: @quiz.next_number
    else
      @question = Question.create type: params[:format]
    end
    redirect_to edit_question_path(@question)
  end

  def edit
    question = Question.find params[:id]
    question.options.create if params[:add]
    Option.destroy(params[:destroy]) if params[:destroy]
    @quiz_id = params[:quiz_id]
    @quest_form = EditQuestionForm.new question
    respond_to do |format|
      format.html { render 'edit' }
      format.js {}
    end
  end

  def update
    question = Question.find params[:id]
    if !params[:question][:quiz_id].nil?
      quiz = Quiz.find question.relationships.find_by_quiz_id(params[:question][:quiz_id]).quiz_id
      question_params.delete :quiz_id
    end
    @quest_form = EditQuestionForm.new question
    if @quest_form.validate_and_save question_params
      flash[:success] = 'Updated Question!'
      if quiz
        redirect_to edit_quiz_path(quiz)
      else
        redirect_to staff_dashboard_path
      end
    else
      render 'edit'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:success] = 'Deletion successful'
    redirect_to edit_quiz_path(@question.quiz_id)
  end

  private

  def question_params
    params.require(:question).permit!
  end
end
