# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :index, to: :see
    alias_action :view, to: :check

    if user.staff?
      can :manage, :all
    elsif user.student?
      can :make_request, Quiz
      can [:take, :submit], Quiz if user.approved_request?
      can :see, :student_dashboard
      can :check, Student if user.taking_quiz?
      can :lock, QuizLock, student_id: user.id
      can [:edit, :update], User
    end
  end
end
