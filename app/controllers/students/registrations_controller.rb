# Only let students register
class Students::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = nil)
    self.resource = Student.new_with_session(hash || {}, session)
  end
end