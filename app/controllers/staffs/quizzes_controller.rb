# Controller for quizzes
module Staffs
  class QuizzesController < BaseController
    load_and_authorize_resource except: :create

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
      @lessons = Quiz::LESSON_VALUES
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
      @lessons = Quiz::LESSON_VALUES
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
      @grades.size == 0 ? 0 : @avg /= @grades.size
    end

    private

    def quiz_params
      params.require(:quiz).permit!
    end
  end
end
