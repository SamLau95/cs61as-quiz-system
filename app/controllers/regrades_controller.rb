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

  def destroy
  end

  private

  def regrade_params
  	params.require(:regrade).permit!
  end
end
