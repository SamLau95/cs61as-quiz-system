class Ability
  include CanCan::Ability

  def initialize(user)
    user = current_user || User.new

    if user.staff?
      can :manage, :all
    elsif user.student?
      can :read, :all
    end
    
  end
end
