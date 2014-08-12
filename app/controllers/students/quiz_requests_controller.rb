# Controller for approving/cancelling quiz requests
module Students
  class QuizRequestsController < BaseController
    def destroy
      QuizRequest.destroy params[:id]
      flash[:success] = 'Cancelled quiz request!'
      redirect_to staff_dashboard_path
    end
  end
end
