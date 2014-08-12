module Students
  class RegradesController < BaseController
    def create
      quiz = Quiz.find params[:regrade][:quiz_id]
      regrade = Regrade.new regrade_params
      @taken_quiz = TakenQuiz.find_by(quiz_id: params[:regrade][:quiz_id],
                                      student_id: current_user.id)
      if regrade.save
        flash[:success] = "You've submitted a regrade request!"
        @taken_quiz.undo
      else
        flash[:error] = "You didn't fill out all the required fields!"
      end
      redirect_to quiz_path(@taken_quiz)
    end

    private

    def regrade_params
      params.require(:regrade).permit!
    end
  end
end
