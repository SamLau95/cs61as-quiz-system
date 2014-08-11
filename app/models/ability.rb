# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:edit, :update], User, id: user.id

    if user.staff?
      can :manage, :staff_dashboard
    elsif user.student?
      can :manage, :student_dashboard
    end
  end
end
