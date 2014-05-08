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
  end

  def bank
    @questions = Question.where(lesson: params[:id]).includes(:solution)
    @requests = QuizRequest.all
    @add = params[:add] == 'true'
    @id = params[:quiz_id]
  end

  def add
    id, qid = params[:id], params[:quiz_id]
    Relationship.where(question_id: id, quiz_id: qid).first_or_create
    flash[:success] = 'Added question from question bank!'
    redirect_to edit_quiz_path(params[:quiz_id])
  end
end
