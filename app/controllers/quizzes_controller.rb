# Controller for quizzes
class QuizzesController < ApplicationController
  load_and_authorize_resource

  [MCQuestion, CodeboxQuestion, TextboxQuestion, CheckboxQuestion] if Rails.env == 'development'

  def make_request
    if current_user.quiz_request.nil?
      QuizRequest.create student: current_user,
                         lesson: params[:lesson]
      flash[:success] = "Requesting quiz #{params[:lesson]}!"
    else
      flash[:alert] = 'You are already requesting to take a quiz!'
    end
    redirect_to student_dashboard_path
  end

  def take
    @quiz_form = TakeQuizForm.new Quiz.choose_one(params[:lesson])
  end

  def submit
    @quiz_form = TakeQuizForm.new Quiz.find(params[:id])
    inject_current_user_into! params
    if @quiz_form.validate_and_save params[:quiz]
      flash[:success] = "Submitted quiz #{@quiz_form.lesson}!"
      redirect_to student_dashboard_path
    else
      render 'take'
    end
  end

  def new
    @quiz_form = Quiz.create_with_question
    redirect_to edit_quiz_path @quiz_form.id
  end

  def create
    @quiz = Quiz.new quiz_params
    if @quiz.save
      redirect_to quizzes_path, notice: 'Created quiz.'
    else
      render :new
    end
  end

  def edit
    quiz = Quiz.find params[:id]
    @quiz_form = EditQuizForm.new quiz
    @questions = quiz.questions.includes(:options)
    Question.destroy(params[:destroy]) if params[:destroy]
    @types = Question.subclasses
    respond_to do |format|
      format.html { render 'edit' }
      format.js {}
    end
  end

  def update
    @quiz_form = EditQuizForm.new Quiz.find params[:id]
    if @quiz_form.validate_and_save quiz_params
      quiz = Quiz.find params[:id]
      flash[:success] = "Updated #{ quiz.full_name }!"
      redirect_to staff_dashboard_path
    else
      render :edit
    end
  end

  def destroy
    Quiz.find(params[:id]).destroy
    redirect_to staff_dashboard_path, notice: 'Deleted quiz.'
  end

  def show
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions.includes(:options)
  end

  private

  def inject_current_user_into!(quiz_params)
    submissions_params = quiz_params[:quiz][:new_submissions_attributes]
    submissions_params.each { |_, v| v[:student_id] = current_user.id }
  end

  def quiz_params
    params.require(:quiz).permit!
  end
end
