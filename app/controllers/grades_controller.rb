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
    @rlt = Relationship.find_by question_id: @question,
                                quiz_id: @submission.quiz_id
  end

  def update
    grade = Grade.find params[:id]
    oldg, newg = grade.grade, params[:grade][:grade].to_f
    @submission = Submission.find_by question_id: grade.question_id,
                                     student_id: grade.student_id
    @question = Question.find grade.question_id
    @grade_form = EditGradeForm.new grade
    quiz = Quiz.find(params[:quiz_id])
    if @grade_form.validate_and_save grade_params
      tq = TakenQuiz.find_by student_id: grade.student_id, quiz_id: quiz
      tq.update_attribute(:grade, g)
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
