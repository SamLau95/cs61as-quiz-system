class TakenQuizzesController < ApplicationController
  def update
    @grade = TakenQuiz.find params[:id]
    if @grade.update_attributes taken_quiz_params
      flash[:notice] = 'Added comment!'
    else
      flash[:error] = "There was something wrong!"
    end
    redirect_to :back
  end

  private

  def taken_quiz_params
    params.require(:taken_quiz).permit!
  end
end