# Controller for approving/cancelling quiz requests
module Staffs
  class QuizRequestsController < BaseController
    before_action :set_quiz_request, only: :approve

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
      QuizRequest.destroy params[:id]
      flash[:success] = 'Cancelled quiz request!'
      redirect_to current_user.staff? ? staff_dashboard_path :
                                        student_dashboard_path
    end

    private

    def set_quiz_request
      @quiz_request = QuizRequest.find params[:id]
    end
  end
end
