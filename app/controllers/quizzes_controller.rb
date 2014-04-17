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
    quiz_lock = current_user.quiz_lock
    # for testing
    # quiz_request = QuizRequest.create(student_id: 1, lesson: 1)
    @quiz_form = TakeQuizForm.new quiz_lock.quiz
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
    # This is breaking since we have validations for quizzes
    @new_quiz = Quiz.create
    redirect_to edit_quiz_path(@new_quiz), notice: 'Created Quiz'
  end

  def create
    if params[:quiz][:quiz_type]
      if params[:quiz][:lesson].empty?
        redirect_to :back, notice: 'Invalid Lesson Number'
      else
        @quiz = Quiz.generate_random(params[:quiz][:lesson])
        redirect_to edit_quiz_path(@quiz), notice: 'Created quiz.'
      end
    end
  end

  def edit
    quiz = Quiz.find params[:id]
    @quiz_form = EditQuizForm.new quiz
    @questions = quiz.questions.includes(:options)
    Question.destroy(params[:destroy]) if params[:destroy]
    respond_to do |format|
      format.html { render 'edit' }
      format.js {}
    end
  end

  def update
    quiz = Quiz.find params[:id]
    @quiz_form = EditQuizForm.new quiz
    if @quiz_form.validate_and_save params[:quiz]
      flash[:success] = "Updated #{quiz}!"
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
