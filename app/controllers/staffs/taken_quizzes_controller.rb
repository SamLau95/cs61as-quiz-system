module Staffs
  class TakenQuizzesController < BaseController
    def update
      @taken_quiz = TakenQuiz.find params[:id]
      if @taken_quiz.update_attributes taken_quiz_params
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
end
