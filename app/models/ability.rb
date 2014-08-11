# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:edit, :update], User, id: user.id

    if user.staff?
      can :manage, :all
    elsif user.student?
      can :manage, :self_only
    end
  end
end
