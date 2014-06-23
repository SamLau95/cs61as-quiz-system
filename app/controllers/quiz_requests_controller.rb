# Controller for approving/cancelling quiz requests
class QuizRequestsController < ApplicationController
  load_and_authorize_resource

  def approve
    request = QuizRequest.find(params[:id])
    request.lock_and_destroy!
    flash[:success] = "Approved #{request.student}!"
    redirect_to staff_dashboard_path
  end

  def cancel
    request = QuizRequest.find(params[:id]).destroy
    flash[:success] = 'Cancelled quiz request!'
    redirect_to @current_user.staff? ? staff_dashboard_path :
                                       student_dashboard_path
  end
end
