# Controller for staff dashboard
class StaffDashboardController < ApplicationController
  authorize_resource class: false

  def index
    @students = Student.all
    @drafts = Quiz.drafts
    @published = Quiz.published
    @requests = QuizRequest.all
    @lessons = Quiz.all_lessons
    @quiz = Quiz.new
    @regrades = Regrade.not_graded
    @download = downloads
    @to_grade = TakenQuiz.not_graded
  end

  def questions
  end

  def requests
  end

  def students
  end

  def grading
  end

  def bank
    @questions = Question.where(lesson: params[:id]).includes(:solution)
    @requests = QuizRequest.all
    @add = params[:add] == 'true'
    @id = params[:quiz_id]
  end

  def add
    id, qid = params[:id], params[:quiz_id]
    quiz = Quiz.find params[:quiz_id]
    quest = Question.find params[:id]
    if quiz.can_add? quest
      Relationship.where(question_id: id, quiz_id: qid).first_or_create
      flash[:success] = 'Added question from question bank!'
      redirect_to edit_quiz_path(params[:quiz_id])
    else
      @lesson = Quiz.all_lessons
      flash[:error] = 'This question has already been used on a retake!'
      redirect_to question_bank_path(id: quiz.lesson,
                                     add: true,
                                     quiz_id: quiz.id)
    end
  end

  def download
    respond_to do |format|
      format.html { redirect_to staff_dashboard_path }
      format.csv { send_data Student.get_csv(params[:lesson]),
                             filename: "lesson#{params[:lesson]}.csv" }
    end
  end

  private

  def downloads
    download = []
    (1..14).each do |n|
      download << ["Lesson #{n}", n.to_s]
    end
    download
  end
end
