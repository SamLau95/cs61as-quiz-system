class StudentDashboardController < ApplicationController
  before_filter :check_authorization

  def index
    @quizzes = Quiz.all
  end

  private
    def check_authorization
      authorize! :take, Quiz
    end
end