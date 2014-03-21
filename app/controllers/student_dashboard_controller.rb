# Controller for the student dashboard
class StudentDashboardController < ApplicationController
  def index
    @lessons = Quiz.lessons
    @quiz_request = current_user.quiz_request
  end

  private

  def check_authorization
    authorize! :request, Quiz
  end
end
