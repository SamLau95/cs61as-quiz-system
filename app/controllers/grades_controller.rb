# Controller for Grades
class GradesController < ApplicationController
  def new
    qid, sid = params[:qid], params[:sid]
    @question = Question.find qid
    @grade = Grade.where(question_id: qid,
                         student_id: sid,
                         lesson: @question.lesson).first_or_create
    redirect_to edit_grade_path(@grade)
  end

  def edit
    grade = Grade.find params[:id]
    @submission = Submission.find_by question_id: grade.question_id,
                                     student_id: grade.student_id
    @question = Question.find grade.question_id
    @grade_form = EditGradeForm.new grade
  end

  def update
    grade = Grade.find params[:id]
    g = grade.grade
    @submission = Submission.find_by question_id: grade.question_id,
                                     student_id: grade.student_id
    @question = Question.find grade.question_id
    @grade_form = EditGradeForm.new grade
    quiz = Quiz.find(params[:quiz_id])
    grade_params[:retake] = quiz.retake
    if @grade_form.validate_and_save grade_params
      tq = TakenQuiz.find_by student_id: grade.student_id,
                             quiz_id: quiz
      tq.update_attribute(:grade, params[:grade][:grade].to_i + tq.grade - g)
      redirect_to view_quiz_path(grade.student_id, quiz_id: quiz)
    else
      render 'edit'
    end
  end

  private

  def grade_params
    params.require(:grade).permit!
  end
end
