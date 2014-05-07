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
    @questions = Question.where lesson: params[:id]
    @requests = QuizRequest.all
  end
end
