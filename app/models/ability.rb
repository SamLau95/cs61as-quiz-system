# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.staff?
      can :manage, :all
    elsif user.student?
      can [:take, :request], Quiz
    end
  end
end
