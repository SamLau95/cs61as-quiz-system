module Students
  class RegradesController < BaseController
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
      redirect_to student_quiz_path(student_id: params[:regrade][:student_id],
                                    id: params[:regrade][:quiz_id])
    end

    private

    def regrade_params
      params.require(:regrade).permit!
    end
  end
end
