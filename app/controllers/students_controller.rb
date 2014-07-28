# Student controller
class StudentsController < ApplicationController
  load_and_authorize_resource

  def show
    @student = Student.find params[:id]
    @taken = @student.quizzes_taken
  end

  def view
    stu_id, qid = params[:id], params[:quiz_id]
    @student_id = stu_id
    @quiz = Quiz.find qid
    @questions = @quiz.questions
    @subm = @questions.map do |q|
      Submission.find_by question_id: q.id, student_id: stu_id
    end
    @scores = @questions.map do |q|
      Grade.find_by question_id: q.id, student_id: stu_id
    end
    @ques_subm = QuizSubmission.new(@questions, @subm, @scores).ques_subm
    @grade = TakenQuiz.find_by(quiz_id: qid, student_id: stu_id)
    @request = Regrade.find_by quiz_id: qid, student_id: stu_id
    @regrade = Regrade.new
    @not_graded = @scores.inject { |q1, q2| q1.nil? || q2.nil? }
  end

  def finish
    TakenQuiz.find_by(student_id: params[:id],
                      quiz_id: params[:quiz_id]).finish
    re = Regrade.find_by(student_id: params[:id],
                         quiz_id: params[:quiz_id])
    re.finish unless re.blank?
    flash[:success] = 'Finished grading!'
    redirect_to staff_dashboard_path
  end
end
