# Regrade Controller
class RegradesController < ApplicationController
  def create
    quiz = Quiz.find params[:regrade][:quiz_id]
    regrade = Regrade.new regrade_params
    if regrade.save
      flash[:success] = "You've submitted a regrade request!"
      TakenQuiz.find_by(quiz_id: params[:regrade][:quiz_id],
                        student_id: current_user.id).undo
    else
      flash[:error] = "You didn't fill out all the required fields!"
    end
    redirect_to view_quiz_path(params[:regrade][:student_id],
                               quiz_id: params[:regrade][:quiz_id])
  end

  def destroy
    Regrade.find(params[:id]).destroy!
    flash[:success] = "You've deleted the regrade request.
                       The student can now request another one"
    redirect_to staff_dashboard_path
  end

  private

  def regrade_params
    params.require(:regrade).permit!
  end
end
