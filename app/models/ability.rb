# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :index, to: :view

    if user.staff?
      can :manage, :all
    elsif user.student?
      can :make_request, Quiz
      can :take, Quiz if user.approved_request?
      can :view, :student_dashboard
    end
  end
end
