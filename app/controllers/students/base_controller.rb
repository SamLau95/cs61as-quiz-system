module Students
  class BaseController < ApplicationController
    before_action :authorize_student!

    private

    def authorize_student!
      authenticate_user!
      authorize! :manage, :students_dashboard
    end
  end
end
