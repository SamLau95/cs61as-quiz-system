module Students
  class BaseController < ApplicationController
    before_action :authorize_student!

    private

    def authorize_student!
      authenticate_user!
      authorize! :manage, :self_only
    end
  end
end
