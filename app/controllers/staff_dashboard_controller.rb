# Controller for staff dashboard
class StaffDashboardController < ApplicationController
  authorize_resource class: false

  def index
    @students = Student.all
    @quizzes = Quiz.all
    @requests = QuizRequest.all
  end
end
