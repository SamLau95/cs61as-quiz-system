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
      can [:take, :submit], Quiz if user.approved_request?
      can :view, :student_dashboard
      can :lock, QuizLock, student_id: user.id
      can [:edit, :update], User
    end
  end
end
