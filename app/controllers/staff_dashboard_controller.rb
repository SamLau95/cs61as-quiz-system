# Controller for staff dashboard
class StaffDashboardController < ApplicationController
  authorize_resource class: false

  [MCQuestion, CodeboxQuestion, TextboxQuestion,
   CheckboxQuestion] if Rails.env == 'development'

  def index
    @students = Student.all
    @drafts = Quiz.drafts
    @published = Quiz.published
    @requests = QuizRequest.not_approved
    @types = Question.subclasses
    @lessons = Quiz.all_lessons
    @quiz = Quiz.new
  end

  def bank
    @questions = Question.where lesson: params[:id]
    @requests = QuizRequest.all
  end
end
