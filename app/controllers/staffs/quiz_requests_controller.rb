# Controller for approving/cancelling quiz requests
module Staffs
  class QuizRequestsController < ApplicationController
    load_and_authorize_resource

    def index
      @requests = QuizRequest.all
      @regrades = Regrade.not_graded
    end

    def approve
      @quiz_request.lock_and_destroy!
      flash[:success] = "Approved #{@quiz_request.student}!"
      redirect_to staff_dashboard_path
    end

    def destroy
      @quiz_request.destroy
      flash[:success] = 'Cancelled quiz request!'
      redirect_to current_user.staff? ? staff_dashboard_path :
                                        student_dashboard_path
    end
  end
end
