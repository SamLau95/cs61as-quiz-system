# Controller for Grades
class GradesController < ApplicationController
  def new
    qid, sid = params[:qid], params[:sid]
    @question = Question.find qid
    @grade = Grade.create(question_id: qid, student_id: sid)
    redirect_to edit_grade_path(@grade, lesson: @question.lesson)
  end

  def edit
    grade = Grade.find params[:id]
    @submission = Submission.where question_id: grade.question_id,
                                   student_id: grade.student_id
    @question = Question.find grade.question_id
    @grade_form = EditGradeForm.new grade
    @lesson = params[:lesson]
  end

  def update
    1/0
  end
end
