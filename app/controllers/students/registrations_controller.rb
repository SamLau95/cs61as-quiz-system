# Only let students register
class Students::RegistrationsController < Devise::RegistrationsController
  def new
    flash[:info] = 'To sign up, please contact your local TA!'
    redirect_to root_path
  end

  def create
    flash[:info] = 'Registrations are not open!'
    redirect_to root_path
  end

  def build_resource(hash = nil)
    self.resource = Student.new_with_session(hash || {}, session)
  end
end
