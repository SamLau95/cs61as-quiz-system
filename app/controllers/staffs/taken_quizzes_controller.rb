module Staffs
  class TakenQuizzesController < BaseController
    def update
      @taken_quiz = TakenQuiz.find params[:taken_quiz].delete :taken_id
      if @taken_quiz.update_attributes taken_quiz_params
        flash[:notice] = 'Added changes!'
      else
        flash[:error] = 'Invalid login or comment.'
      end
      redirect_to staffs_student_quiz_path(@taken_quiz.student,
                                           @taken_quiz.quiz)
    end

    private

    def taken_quiz_params
      params.require(:taken_quiz).permit!
    end
  end
end
