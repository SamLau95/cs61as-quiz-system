# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can [:edit, :update], User, id: user.id

    if user.staff?
      can :manage, :all
      cannot [:edit, :update], User, :id => (0...user.id).to_a + ((user.id + 1)..User.all.count).to_a
      cannot :see, Students::DashboardController
    elsif user.student?
      can :manage, :self_only
      # can :show, Staffs::Students::QuizzesController
    end
  end
end
