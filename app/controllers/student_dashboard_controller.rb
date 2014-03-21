# Controller for the student dashboard
class StudentDashboardController < ApplicationController
  authorize_resource class: false

  def index
    @lessons = Quiz.lessons
    @quiz_request = current_user.quiz_request
  end
end
