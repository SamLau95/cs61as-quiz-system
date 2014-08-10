class TakenQuizzesController < ApplicationController
  load_and_authorize_resource

  def update
    @grade = TakenQuiz.find params[:id]
    if @grade.update_attributes taken_quiz_params
      flash[:notice] = 'Added comment!'
    else
      flash[:error] = 'Comment was left blank or was too long.'
    end
    redirect_to :back
  end

  private

  def taken_quiz_params
    params.require(:taken_quiz).permit!
  end
end
