# Controller for approving/cancelling quiz requests
class QuizRequestsController < ApplicationController
  load_and_authorize_resource

  def approve
    request = QuizRequest.find(params[:id])
    request.approve!
    flash[:success] = "Approved #{request.student}!"
    redirect_to staff_dashboard_path
  end

  def cancel
    request = QuizRequest.find(params[:id]).destroy
    flash[:success] = "Cancelled #{request.student}'s request!"
    redirect_to staff_dashboard_path
  end
end
