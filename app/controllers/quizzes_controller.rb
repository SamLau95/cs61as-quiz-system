# Controller for quizzes
class QuizzesController < ApplicationController
  load_and_authorize_resource except: :create

  def make_request
    cu, les = current_user, params[:lesson]
    if can_take? les
      check_quiz_and_make_request(cu, les)
    else
      flash[:alert] = "You can't request this quiz!"
    end
    redirect_to student_dashboard_path
  end

  def take
    quiz_lock = current_user.quiz_loc
    @quiz_form = TakeQuizForm.new quiz_lock.quiz
    gon.push lock_path: lock_student_path(quiz_lock),
             time_left: quiz_lock.time_left
  end

  def submit
    ql = QuizLock.find_by_student_id(current_user.id)
    if ql.locked
      flash[:error] = 'You wish you could turn this in.'
      redirect_to student_dashboard_path
    else
      q = Quiz.find(params[:id])
      @quiz_form = TakeQuizForm.new q
      inject_current_user_into! params
      if @quiz_form.validate_and_save params[:quiz]
        TakenQuiz.create student_id: ql.student_id,
                         quiz_id: ql.quiz_id,
                         lesson: q.lesson
        ql.destroy
        flash[:success] = "Submitted quiz #{@quiz_form.lesson}!"
        redirect_to student_dashboard_path
      else
        render 'take'
      end
    end
  end

  def new
    @new_quiz = Quiz.create
    redirect_to edit_quiz_path(@new_quiz), notice: 'Created Quiz'
  end

  def create
    if params[:quiz][:quiz_type]
      if params[:quiz][:lesson].empty?
        redirect_to :back, notice: 'Invalid Lesson Number'
      else
        lesson, rtk = params[:quiz][:lesson], params[:quiz][:retake]
        @quiz = Quiz.generate_random(lesson, rtk)
        redirect_to edit_quiz_path(@quiz), notice: 'Created quiz.'
      end
    end
  end

  def edit
    quiz = Quiz.find params[:id]
    @quiz_form = EditQuizForm.new quiz
    @questions = quiz.questions
    @lessons = Quiz.all_lessons
    Question.destroy(params[:destroy]) if params[:destroy]
    respond_to do |format|
      format.html { render 'edit' }
      format.js {}
    end
  end

  def update
    quiz = Quiz.find params[:id]
    @quiz_form = EditQuizForm.new quiz
    @questions = quiz.questions
    @lessons = Quiz.all_lessons
    if @quiz_form.validate_and_save quiz_params
      flash[:success] = "Updated #{quiz}!"
      redirect_to staff_dashboard_path
    else
      render :edit
    end
  end

  def destroy
    Quiz.find(params[:id]).destroy
    redirect_to staff_dashboard_path, notice: 'Deleted quiz.'
  end

  def delete_question
    qid, quest_id = params[:id], params[:quest_id]
    quiz = Quiz.find qid
    if quiz.is_draft    
      Relationship.find_by(quiz_id: qid, question_id: quest_id).destroy
      flash[:success] = 'Removed question from quiz.'
    else 
      flash[:error] = "Can't remove question from published quiz!"
    end
    redirect_to edit_quiz_path(quiz)
  end

  def show
    @quiz = Quiz.find(params[:id])
    @questions = @quiz.questions
  end

  def stats
    @quiz = Quiz.find(params[:id])
    @grades = TakenQuiz.where(quiz_id: params[:id])
    @students, @avg = [], 0
    @grades.each do |g|
      s = Student.find(g.student_id)
      @students << [s.to_s, s.login, g.grade]
      @avg += g.grade
    end
    @avg /= @grades.size
  end

  private

  def can_take?(lesson)
    (!current_user.making_request? || !current_user.taking_quiz?) &&
    current_user.retake(params[:lesson]) < 2
  end

  def inject_current_user_into!(quiz_params)
    submissions_params = quiz_params[:quiz][:new_submissions_attributes]
    submissions_params.each { |_, v| v[:student_id] = current_user.id }
  end

  def quiz_params
    params.require(:quiz).permit!
  end

  def check_quiz_and_make_request(cu, les)
    re = current_user.retake(les) == 1
    if Quiz.has_quiz(les, re).blank?
      flash[:notice] = "We don't currently have this quiz - please tell us!"
    else
      QuizRequest.create student: cu, lesson: les, retake: re
      flash[:success] = "Requesting quiz #{params[:lesson]}!"
    end
  end
end
