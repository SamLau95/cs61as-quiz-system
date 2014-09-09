# Controller for QuizLocks
module Students
  class QuizLocksController < BaseController
    before_action :load_and_authorize_quiz_lock

    def lock
      @quiz_lock.lock!
      respond_to do |format|
        format.js
      end
    end

    def unlock
      user = Staff.find_by_login params[:staff_id]
      if !user.nil? && user.valid_password?(params[:password])
        QuizLock.find(params[:id]).unlock!
        flash[:success] = "Don't try switching windows!"
        redirect_to take_students_quizzes_path
      else
        flash[:error] = 'Invalid login/password'
        redirect_to students_dashboard_path
      end
    end

    private

    def load_and_authorize_quiz_lock
      @quiz_lock = QuizLock.find params[:id]
      deny_access_if! @quiz_lock.student != current_user
    end
  end
end
