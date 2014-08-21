module Students
  class QuizzesController < BaseController
    skip_before_filter :verify_authenticity_token, only: :submit
    def make_request
      student, lesson = current_user, params[:lesson]
      if can_take_quiz_for_lesson? lesson
        check_quiz_and_make_request(student, lesson)
      else
        flash[:alert] = "You can't request this quiz!"
      end
      redirect_to students_dashboard_path
    end

    def take
      quiz_lock = current_user.quiz_lock
      deny_access_unless! quiz_lock.present?
      @quiz_form = TakeQuizForm.new quiz_lock.quiz
      gon.push lock_path: lock_students_quiz_lock_path(quiz_lock),
               time_left: quiz_lock.time_left
    end

    def submit
      ql = QuizLock.find_by_student_id(current_user.id)
      quiz = Quiz.find ql.quiz_id
      if ql.locked
        flash[:error] = 'You wish you could turn this in.'
        redirect_to students_dashboard_path
      else
        q = Quiz.find(params[:id])
        @quiz_form = TakeQuizForm.new q
        inject_current_user_into! params
        if @quiz_form.validate_and_save params[:quiz]
          TakenQuiz.create student_id: ql.student_id,
                           quiz_id: ql.quiz_id,
                           lesson: q.lesson,
                           retake: quiz.retake,
                           staff_id: Staff.assign_grader.id
          ql.destroy
          flash[:success] = "Submitted quiz #{@quiz_form.lesson}!"
          redirect_to students_dashboard_path
        else
          render 'take'
        end
      end
    end

    def show
      @grade = TakenQuiz.find params[:id]
      @quiz, @student = @grade.quiz, current_user
      @questions = @quiz.questions
      @subm = @questions.map { |q| q.submissions.find_by student: @student }
      @scores = @questions.map { |q| q.grades.find_by student: @student }
      @ques_subm = QuizSubmission.new(@questions, @subm, @scores).ques_subm
      @request = Regrade.find_by quiz: @quiz, student: @student
      @regrade = Regrade.new
      @not_graded = @scores.inject(false) { |q, q2| q || q2.nil? }
    end

    private

    def can_take_quiz_for_lesson?(lesson)
      (!current_user.making_request? || !current_user.taking_quiz?) &&
      current_user.retake(lesson) < 2
    end

    def inject_current_user_into!(quiz_params)
      submissions_params = quiz_params[:quiz][:new_submissions_attributes]
      submissions_params.each { |_, v| v[:student_id] = current_user.id }
    end

    def check_quiz_and_make_request(cu, les)
      re = current_user.retake(les) == 1
      if !Quiz.has_quiz(les, re)
        flash[:notice] = "We don't currently have this quiz - please tell us!"
      else
        QuizRequest.create student: cu, lesson: les, retake: re
        flash[:success] = "Requesting quiz #{params[:lesson]}!"
      end
    end
  end
end
