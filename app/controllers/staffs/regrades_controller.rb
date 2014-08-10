module Staffs
  class RegradesController < ApplicationController
    def destroy
      Regrade.find(params[:id]).destroy!
      flash[:success] = "You've deleted the regrade request.
                         The student can now request another one"
      redirect_to staff_dashboard_path
    end
  end
end
