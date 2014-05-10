# Question Controller
class QuestionsController < ApplicationController
  load_and_authorize_resource

  def new
    if params[:quiz_id]
      @quiz = Quiz.find params[:quiz_id]
      @question = @quiz.questions.create lesson: @quiz.lesson
      add_pts, lesson = true, false
    else
      @question = Question.create
      add_pts, lesson= false, true 
    end
    @question.create_solution
    redirect_to edit_question_path(@question,
                                   quiz_id: params[:quiz_id],
                                   add_pts: add_pts,
                                   lesson: lesson,
                                   points: @points)
  end

  def edit
    @add_pts = params[:add_pts]
    @lesson = params[:lesson]
    question = Question.find params[:id]
    question.solution
    @quiz_id = params[:quiz_id]
    @quest_form = EditQuestionForm.new question
    rlt = Relationship.find_by_quiz_id(params[:quiz_id])
    @points = rlt.nil? ? 0 : rlt.points
  end

  def update
    @add_pts = params[:add_pts]
    @lesson = params[:lesson]
    @points = params[:points]
    question = Question.find params[:id]
    @quiz_id = params[:question][:quiz_id]
    quiz = Quiz.find @quiz_id unless @quiz_id.empty?
    question_params[:points] = params[:points]
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
    redirect_to :back
  end

  private

  def question_params
    params.require(:question).permit!
  end
end
