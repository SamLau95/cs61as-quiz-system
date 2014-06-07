  # Question Controller
class QuestionsController < ApplicationController
  load_and_authorize_resource except: :create

  def new
    if params[:quiz_id]
      @quiz_id = params[:quiz_id]
      @quiz = Quiz.find params[:quiz_id]
      question = @quiz.questions.new lesson: @quiz.lesson
      @add_pts = 'true'
    else
      question = Question.new
      @add_pts = 'false'
    end
    @lesson = 'true'
    question.solution = Solution.new
    @quest_form = NewQuestionForm.new question
  end

  def create
    @add_pts, @lesson = params[:add_pts], params[:lesson]
    @points = params[:points].blank? ? 0 : params[:points]
    question = createQues
    @quiz_id = params[:quiz_id]
    quiz = Quiz.find_by_id @quiz_id
    question_params[:points] = { pts: @points, qid: @quiz_id }
    @quest_form = NewQuestionForm.new question
    if @quest_form.validate_and_save question_params
      flash[:success] = 'Created Question!'
      if quiz
        redirect_to edit_quiz_path(quiz)
      else
        redirect_to staff_dashboard_path
      end
    else
      render 'new'
    end
  end

  def edit
    @add_pts = params[:add_pts]
    @lesson = params[:lesson]
    question = Question.find params[:id]
    @quiz_id = params[:quiz_id]
    @quest_form = EditQuestionForm.new question
    rlt = Relationship.find_by(quiz_id: params[:quiz_id],
                               question_id: question.id)
    @points = rlt.nil? ? 0 : rlt.points
  end

  def update
    @add_pts, @lesson = params[:add_pts], params[:lesson]
    @points = params[:points]
    question = Question.find params[:id]
    @quiz_id = params[:quiz_id]
    quiz = Quiz.find @quiz_id unless @quiz_id.empty?
    question_params[:points] = { pts: @points, qid: @quiz_id }
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

  def createQues
    solution = Solution.new question_params[:solution_attributes]
    question_params.delete :solution_attributes
    question = Question.new question_params
    question.solution = solution
    question
  end
end
