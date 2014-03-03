class Ability
  include CanCan::Ability

  def initialize(user)
    user = current_user || User.new

    if user.staff?
      can :manage, :all
    else
      can :read, :all
    end
    
  end
end
