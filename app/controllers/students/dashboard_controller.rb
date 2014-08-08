# Controller for the student dashboard
module Students
  class DashboardController < ApplicationController
    def index
      @lessons = Quiz.lessons
      @quiz_request = current_user.quiz_request
      @quiz_lock = current_user.quiz_lock
      @taken = TakenQuiz.sort_quizzes(current_user.taken_quizzes).map do |q|
        Quiz.find(q.quiz_id)
      end
    end
  end
end
