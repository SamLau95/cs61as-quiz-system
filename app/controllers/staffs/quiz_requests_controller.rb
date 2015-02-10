# Controller for approving/cancelling quiz requests
module Staffs
  class QuizRequestsController < BaseController
    before_action :set_quiz_request, only: [:approve, :choose]

    def index
      @requests = QuizRequest.all
      @regrades = Regrade.not_graded
    end

    def choose
      @quiz_request.lock_and_destroy! params[:quiz_id], params[:quiz_time]
      approve_flash
    end

    def destroy
      request = QuizRequest.find_by_id(params[:id])
      if request
        request.destroy
      end
      flash[:success] = 'Cancelled quiz request!'
      redirect_to staffs_dashboard_path
    end

    private

    def set_quiz_request
      @quiz_request = QuizRequest.find params[:id]
    end

    def approve_flash
      flash[:success] = "Approved #{@quiz_request.student}!"
      redirect_to staffs_quiz_requests_path
    end
  end
end
