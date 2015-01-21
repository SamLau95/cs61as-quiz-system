# Question Controller
module Staffs
  class QuestionsController < BaseController
    before_action :set_question, only: [:edit, :update, :destroy, :add]

    def new
      if params[:quiz_id]
        @quiz_id = params[:quiz_id]
        @quiz = Quiz.find params[:quiz_id]
        question = @quiz.questions.new lesson: @quiz.lesson
        @add_pts = 'true'
      else
        question = Question.new
        @add_pts = 'false'
      end
      @lesson = 'true'
      question.solution = Solution.new
      question.rubric = Rubric.new
      @quest_form = NewQuestionForm.new question
    end

    def create
      quiz = assign_params
      question = CreateQuestion.call question_params.except :points
      @quest_form = NewQuestionForm.new question
      if @quest_form.validate_and_save question_params
        flash[:success] = 'Created Question!'
        redirect_after_editing quiz
      else
        render 'new'
      end
    end

    def index
      @lessons = Quiz::LESSON_VALUES
    end

    def show
      @question = Question.find params[:id]
    end

    def edit
      get_question_options
      @quest_form = EditQuestionForm.new @question
      rlt = Relationship.find_by(quiz_id: params[:quiz_id],
                                 question: @question)
      @points = rlt.nil? ? 0 : rlt.points
    end

    def update
      quiz = assign_params
      @quest_form = EditQuestionForm.new @question
      if @quest_form.validate_and_save question_params
        flash[:success] = 'Updated Question!'
        redirect_after_editing quiz
      else
        render 'edit'
      end
    end

    def destroy
      quizzes = @question.quizzes
      if quizzes.blank?
        @question.destroy
        flash[:success] = 'Deletion successful!'
      else
        used_by = quizzes.map(&:to_s).join ', '
        flash[:error] = "This question is being used by the following quizzes: #{used_by}. Please remove the question on the quiz(zes) first."
      end
      redirect_to :back
    end

    def bank
      @questions = Question.where(lesson: params[:lesson])
                           .includes(:solution).includes(:rubric)
                           .page params[:page]
      @requests = QuizRequest.all
      @add = params[:add] == 'true'
      @id = params[:quiz_id]
    end

    def add
      @quiz = Quiz.find params[:quiz_id]
      if @quiz.can_add? @question
        Relationship.where(question: @question, quiz: @quiz).first_or_create
        flash[:success] = 'Added question from question bank!'
      else
        @lesson = Quiz::LESSON_VALUES
        flash[:error] = 'This question has already been used on a retake!'
      end
      redirect_to edit_staffs_quiz_path @quiz
    end

    def download
      file = Tempfile.new('questions')
      Question.get_assigned_questions.each do |q|
        file.puts "Lesson: #{q.lesson} \n"
        file.puts "Difficulty: #{q.difficulty}\n"
        file.puts "Content:\n#{q.content.truncate 100 } \n\n"
        file.puts "Solution:\n#{q.solution.content}\n\n"
        file.puts "Rubric:\n#{q.rubric.rubric}\n\n"
        file.puts "Total Points: #{q.relationships.first.points}\n\n"
        file.puts "Average Points: #{q.get_average}\n\n\n\n"
      end
      send_file file, filename: 'questions.md'
      file.close
    end

    private

    def set_question
      @question = Question.find params[:id]
    end

    # Bad - explicitly require params
    def question_params
      params.require(:question).permit!
    end

    def redirect_after_editing(quiz)
      if quiz
        redirect_to edit_staffs_quiz_path(quiz)
      else
        redirect_to staffs_questions_path
      end
    end

    def assign_params
      get_question_options
      @points = params[:points]
      question_params[:points] = { pts: @points, qid: @quiz_id }
      quiz = Quiz.find_by_id @quiz_id
    end

    def get_question_options
      @add_pts, @lesson, @quiz_id = params[:add_pts], params[:lesson], params[:quiz_id]
    end
  end
end
