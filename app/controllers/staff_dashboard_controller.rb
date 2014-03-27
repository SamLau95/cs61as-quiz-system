class StaffDashboardController < ApplicationController
  before_filter :check_authorization

  def index
    @students = Student.all
    @drafts = Quiz.drafts
    @published = Quiz.published
  end

  private

  def check_authorization
    authorize! :manage, :all
  end
end
