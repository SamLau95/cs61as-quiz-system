# Student controller
class StudentsController < ApplicationController
  load_and_authorize_resource

  def show
    @student = Student.find params[:id]
    @taken = TakenQuiz.sort_quizzes(@student.taken_quizzes).map do |q|
      Quiz.find(q.quiz_id)
    end
  end
end
