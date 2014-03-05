class StaffDashboardController < ApplicationController
  before_filter :check_authorization

  def index
    @students = Student.all
    @quizzes = Quiz.all
  end

  private
    def check_authorization
      authorize! :manage, :all
    end
end