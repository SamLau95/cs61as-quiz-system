# Controller for staff dashboard
class StaffDashboardController < ApplicationController
  authorize_resource class: false

  def index
    @students = Student.all
    @quizzes = Quiz.all
    @requests = QuizRequest.not_approved
  end
end
