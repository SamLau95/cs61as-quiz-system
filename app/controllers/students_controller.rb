# Student controller
class StudentsController < ApplicationController
  load_and_authorize_resource

  def show
    @student = Student.find params[:id]
    @taken = @student.taken_quizzes
  end

  def view
    id, stu_id = params[:id], params[:student_id]
    @student_id = stu_id
    @quiz = Quiz.find id
    @questions = @quiz.questions.includes(:solution)
    @submissions = Submission.where(quiz_id: id, student_id: stu_id)
                             # .sort_by { |sub| sub.question_number }
    @ques_subm = QuizSubmission.new(@questions, @submissions).ques_subm
    @grade = @quiz.grade(@student_id)
  end
end
