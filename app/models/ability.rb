# Defines authorization for users
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :index, to: :see
    alias_action :view, to: :check

    if !user.added_info
      can [:edit, :update], User, :id => user.id
    elsif user.staff?
      can :manage, :all
      cannot [:edit, :update], User, :id => (0...user.id).to_a + ((user.id + 1)..User.all.count).to_a
      cannot :see, Students::DashboardController
    elsif user.student?
      if user.added_info
        can :destroy, QuizRequest if user.quiz_request
        can :make_request, Quiz
        # Very bad - fix authorization later
        can :show, Quiz
        can [:take, :submit], Quiz if user.approved_request?
        can :see, Students::DashboardController
        can :check, Student unless user.taking_quiz?
        can :lock, QuizLock, student_id: user.id
        can :unlock, QuizLock if !user.approved_request?
      end
      can [:edit, :update], User, :id => user.id
    end
  end
end
