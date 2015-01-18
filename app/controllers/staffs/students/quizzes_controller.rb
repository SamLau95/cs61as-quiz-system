module Staffs::Students
  class QuizzesController < Staffs::BaseController
    def show
      @quiz = Quiz.find params[:id]
      @student = Student.find params[:student_id]
      @questions = @quiz.questions
      @subm = @questions.map { |q| q.submissions.find_by student: @student }
      @scores = @questions.map { |q| q.grades.find_by student: @student }
      @ques_subm = QuizSubmission.new(@questions, @subm, @scores).ques_subm
      @grade = TakenQuiz.find_by quiz: @quiz, student: @student
      @request = Regrade.find_by quiz: @quiz, student: @student
      @not_graded = @scores.inject(false) { |q, q2| q || q2.nil? }
    end

    def finish_grading
      student, quiz = params[:student_id], params[:quiz_id]
      TakenQuiz.find_by(student_id: student, quiz_id: quiz).finish
      Student.find(params[:student_id]).check_if_send_email
      regrade = Regrade.find_by(student_id: student, quiz_id: quiz)
      regrade.finish if regrade
      flash[:success] = 'Finished grading!'
      redirect_to staffs_grades_path
    end
  end
end
