# Controller for the student dashboard
class StudentDashboardController < ApplicationController

  def index
    @lessons = Quiz.lessons
  end

  private

  def check_authorization
    authorize! :take, Quiz
  end
end
