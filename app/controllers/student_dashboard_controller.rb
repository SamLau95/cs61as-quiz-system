# Controller for the student dashboard
class StudentDashboardController < ApplicationController
  authorize_resource class: false

  def index
    @lessons = Quiz.lessons
    @quiz_request = current_user.quiz_request
    @quiz_lock = current_user.quiz_lock
    @taken = current_user.quizzes_taken
  end
end
