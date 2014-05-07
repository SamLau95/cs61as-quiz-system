# Regrade Controller
class RegradesController < ApplicationController
  def create
  	quiz = Quiz.find params[:regrade][:quiz_id]
  	regrade = Regrade.new regrade_params
  	if regrade.save
  		flash[:success] = "You've submitted a regrade request!"
  	else
  		flash[:error] = "You didn't fill out all the required fields!"
  	end
  	redirect_to view_quiz_path(quiz, student_id: params[:regrade][:student_id])
  end

  def change_status
  	regrade = Regrade.find params[:id]
  	regrade.update_attribute(:graded, true)
  	redirect_to staff_dashboard_path
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
