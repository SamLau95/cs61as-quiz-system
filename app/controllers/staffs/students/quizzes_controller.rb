module Staffs::Students
  class QuizzesController < Staffs::BaseController
    def show
      @quiz = Quiz.find params[:id]
      @student = Student.find params[:student_id]
      @questions = @quiz.questions
      @subm = @questions.map do |q|
        Submission.find_by question_id: q.id, student: @student
      end
      @scores = @questions.map do |q|
        Grade.find_by question_id: q.id, student: @student
      end
      @ques_subm = QuizSubmission.new(@questions, @subm, @scores).ques_subm
      @grade = TakenQuiz.find_by quiz: @quiz, student: @student
      @request = Regrade.find_by quiz: @quiz, student: @student
      @regrade = Regrade.new
      @not_graded = @scores.inject(false) { |q, q2| q || q2.nil? }
    end

    def finish_grading
      student, quiz = params[:student_id], params[:quiz_id]
      TakenQuiz.find_by(student_id: student, quiz_id: quiz).finish
      regrade = Regrade.find_by(student_id: student, quiz_id: quiz)
      regrade.finish if regrade
      flash[:success] = 'Finished grading!'
      redirect_to staffs_grades_path
    end
  end
end
