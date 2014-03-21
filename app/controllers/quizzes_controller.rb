# Controller for quizzes
class QuizzesController < ApplicationController
  load_and_authorize_resource

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
    @quiz = Quiz.new
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
    @quiz_form = EditQuizForm.new Quiz.find params[:id]
  end

  def update
    quiz = Quiz.find params[:id]
    @quiz_form = EditQuizForm.new quiz
    if @quiz_form.validate_and_save params[:quiz]
      flash[:success] = "Updated #{quiz.full_name}!"
      redirect_to staff_dashboard_path
    else
      render :edit
    end
  end

  def destroy
    Quiz.find(params[:id]).destroy
    redirect_to quizzes_path, notice: 'Deleted quiz.'
  end

  private

  def inject_current_user_into!(quiz_params)
    submissions_params = quiz_params[:quiz][:new_submissions_attributes]
    submissions_params.each { |_, v| v[:student_id] = current_user.id }
  end
end
