# Controller for QuizLocks
class QuizLocksController < BaseController
  load_and_authorize_resource

  def lock
    quiz_lock = QuizLock.find params[:id]
    quiz_lock.lock!
    respond_to do |format|
      format.js
    end
  end

  def unlock
    user = Staff.find_by_login params[:staff_id]
    if !user.nil? && user.valid_password?(params[:password])
      QuizLock.find(params[:id]).unlock!
      flash[:success] = "Don't try switching windows!"
      redirect_to take_quizzes_path
    else
      flash[:error] = 'Invalid login/password'
      redirect_to student_dashboard_path
    end
  end
end
