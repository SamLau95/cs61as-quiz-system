module Staffs
  class BaseController < ApplicationController
    before_action :authorize_staff!

    private

    def authorize_staff!
      authenticate_user!
      authorize! :manage, :staffs_dashboard
    end
  end
end
