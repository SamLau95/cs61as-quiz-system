# Student controller
class StudentsController < ApplicationController
  load_and_authorize_resource

  def show
    @student = Student.find params[:id]
    @taken = @student.taken_quizzes
  end

  def view
    @student_id = params[:student_id]
    @quiz = Quiz.find params[:id]
    @questions = @quiz.questions.includes(:solution)
    @submissions = Submission.where quiz_id: params[:id],
                                    student_id: params[:student_id]
    @submissions = @submissions.sort_by { |sub| Question.find(sub.question_id).number }
    @ques_subm = QuizSubmission.new(@questions, @submissions).ques_subm
  end

  def grade
    @quiz = Quiz.find params[:id]
  end
end
