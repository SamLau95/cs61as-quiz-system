class QuizzesController < ApplicationController

  def take
    @quiz = Quiz.find params[:id]
    questions = @quiz.questions.order(:number)
    submissions = questions.map { |q| Submission.new }
    @questions_hash = Hash[questions.zip submissions]
  end

  def submit
    quiz = Quiz.find params[:id]
    params['submissions'].map do |question_id, content|
      quiz.submissions.create question: Question.find(question_id),
                              student: current_user,
                              content: content
    end
    flash[:success] = "Submitted quiz #{quiz.lesson}!"
    redirect_to student_dashboard_path
  end

  def save_submission
    submission = Submission.create submission_params
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
    @quiz = Quiz.find params[:id]
  end

  def update
    @quiz = Quiz.find params[:id]
    if @quiz.update_attributes quiz_params
      redirect_to quizzes_path, notice: 'Updated quiz.'
    else
      render :edit
    end
  end

  def destroy
    Quiz.find(params[:id]).destroy
    redirect_to quizzes_path, notice: 'Deleted quiz.'
  end

  private
    def check_authorization
      authorize! :take, Quiz
    end

    def submission_params
      params.require(:submission)
            .permit(:quiz_id, :question_id, :student_id, :content)
    end
end
