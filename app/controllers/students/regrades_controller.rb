module Students
  class RegradesController < BaseController
    def create
      @taken_quiz = TakenQuiz.find regrade_params.delete(:taken_quiz)
      regrade = Regrade.new regrade_params.merge(quiz: @taken_quiz.quiz,
                                                 student: @taken_quiz.student)
      if regrade.save
        flash[:success] = "You've submitted a regrade request!"
        @taken_quiz.undo
      else
        flash[:error] = "You didn't fill out all the required fields!"
      end
      redirect_to students_quiz_path(@taken_quiz)
    end

    private

    def regrade_params
      params.require(:regrade).permit!
    end
  end
end
