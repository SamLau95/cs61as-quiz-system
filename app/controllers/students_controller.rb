# Student controller
class StudentsController < ApplicationController
  def show
    @student = Student.find params[:id]
    @taken = @student.taken_quizzes
  end

  def view
  end
end
