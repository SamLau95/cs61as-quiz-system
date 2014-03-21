# Controller for approving/cancelling quiz requests
class QuizRequestsController < ApplicationController
  load_and_authorize_resource

  def approve
    QuizRequest.find(params[:id]).approve!
    redirect_to staff_dashboard_path
  end

  def cancel
    QuizRequest.find(params[:id]).destroy
    redirect_to staff_dashboard_path
  end
end
