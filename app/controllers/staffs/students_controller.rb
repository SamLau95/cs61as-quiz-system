# Student controller
module Staffs
  class StudentsController < ApplicationController
    load_and_authorize_resource

    def index
      @students = Student.page params[:page]
      @value = params[:search]
      @search = Student.get params[:search]
    end

    def show
      @student = Student.find params[:id]
      @taken = TakenQuiz.sort_quizzes(@student.taken_quizzes).map do |q|
        Quiz.find(q.quiz_id)
      end
    end
  end
end
