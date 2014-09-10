# Controller for approving/cancelling quiz requests
module Students
  class QuizRequestsController < BaseController
    def destroy
      request = current_user.quiz_lock || QuizRequest.find(params[:id])
      request.destroy
      flash[:success] = 'Cancelled quiz request!'
      redirect_to students_dashboard_path
    end
  end
end
