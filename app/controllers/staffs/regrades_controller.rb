module Staffs
  class RegradesController < BaseController
    def destroy
      @regrade = Regrade.destroy params[:id]
      TakenQuiz.find_by(student: @regrade.student_id,
                        quiz: @regrade.quiz_id).finish
      flash[:success] = "You've deleted the regrade request.
                         The student can now request another one"
      redirect_to staffs_dashboard_path
    end
  end
end
