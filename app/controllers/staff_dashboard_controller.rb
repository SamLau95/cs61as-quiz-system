# Controller for staff dashboard
class StaffDashboardController < ApplicationController
  authorize_resource class: false

  def index
    @students = Student.all
    @drafts = Quiz.drafts
    @published = Quiz.published
    @requests = QuizRequest.all
    @types = Question.subclasses
    @lessons = Quiz.all_lessons
    @quiz = Quiz.new
  end

  def bank
    @questions = Question.where lesson: params[:id]
    @requests = QuizRequest.all
  end
end
