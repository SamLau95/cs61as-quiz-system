# Controller for Grades
class GradesController < ApplicationController
  def new
    qid, sid = params[:qid], params[:sid]
    @question = Question.find qid
    @grade = Grade.where(question_id: qid, student_id: sid).first_or_create
    redirect_to edit_grade_path(@grade, lesson: @question.lesson)
  end

  def edit
    grade = Grade.find params[:id]
    @submission = Submission.find_by question_id: grade.question_id,
                                     student_id: grade.student_id
    @question = Question.find grade.question_id
    @grade_form = EditGradeForm.new grade
    @lesson = params[:lesson]
  end

  def update
    grade = Grade.find params[:id]
    @submission = Submission.find_by question_id: grade.question_id,
                                     student_id: grade.student_id
    @question = Question.find grade.question_id

    @grade_form = EditGradeForm.new grade
    quiz = params[:quiz_id]
    if @grade_form.validate_and_save grade_params
      redirect_to view_quiz_path(quiz, student_id: grade.student_id)
    else
      render 'edit'
    end
  end

  private

  def grade_params
    params.require(:grade).permit!
  end
end
