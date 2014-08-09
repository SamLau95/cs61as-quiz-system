# Controller for staff dashboard
module Staffs
  class DashboardController < ApplicationController
    authorize_resource class: false
    before_action :delete_quizzes, only: :index

    def index
      @drafts = Quiz.sort_lesson Quiz.drafts
      @published = Quiz.sort_lesson Quiz.published
      @quiz = Quiz.new
      @download = downloads
    end

    def requests
      @requests = QuizRequest.all
      @regrades = Regrade.not_graded
    end

    def students
      @students = Student.page params[:page]
      @value = params[:search]
      @search = Student.get(params[:search])
    end

    def grading
      @all_to_grade = TakenQuiz.sort_quizzes TakenQuiz.not_graded
      @assigned = TakenQuiz.sort_quizzes @current_user.taken_quizzes.not_graded
    end

    def add
      id, qid = params[:id], params[:quiz_id]
      quiz = Quiz.find params[:quiz_id]
      quest = Question.find params[:id]
      if quiz.can_add? quest
        Relationship.where(question_id: id, quiz_id: qid).first_or_create
        flash[:success] = 'Added question from question bank!'
        redirect_to edit_quiz_path(params[:quiz_id])
      else
        @lesson = Quiz::LESSON_VALUES
        flash[:error] = 'This question has already been used on a retake!'
        redirect_to bank_questions_path(lesson: quiz.lesson,
                                       add: true,
                                       quiz_id: quiz.id)
      end
    end

    def download
      respond_to do |format|
        format.html { redirect_to staff_dashboard_path }
        format.csv do
          send_data Student.get_csv(params[:lesson]),
                    filename: "lesson#{params[:lesson]}.csv"
        end
      end
    end

    def download_questions
      file = Tempfile.new('questions')
      Question.all.each do |q|
        file.puts "Lesson: #{q.lesson} \n"
        file.puts "Difficulty: #{q.difficulty}\n"
        file.puts "Content:\n#{q.content} \n\n"
      end
      send_file file, filename: 'questions.md'
      file.close
    end

    def import_students_form
      @results = []
    end

    def import_students
      @logins = params[:logins]
      @results = @logins.split
                        .reject { |login| Student.find_by_login login }
                        .map { |login| import_student login }
      respond_to do |format|
        format.html { redirect_to staff_dashboard_path }
        format.csv do
          send_data create_student_csv(@results),
                    filename: 'studentInfo.csv'
        end
      end
    end

    def download_initial_passwords
      passwords = Student.all.map { |m| [m.login, m.first_password] }
      respond_to do |format|
        format.html { redirect_to staff_dashboard_path }
        format.csv do
          send_data create_student_csv(passwords),
                    filename: 'studentInitialPW.csv'
        end
      end
    end

    private

    def downloads
      download = []
      Quiz::LESSON_VALUES.each do |n|
        download << ["Lesson #{n}", n]
      end
      download
    end

    def import_student(login)
      password = Devise.friendly_token.first 8
      student = Student.create(login: login, password: password,
                               first_password: password)
      if student.new_record?
        [login, "Not saved. #{student.errors.full_messages.join ' '}"]
      else
        [login, password]
      end
    end

    def create_student_csv(results)
      CSV.generate do |csv|
        csv << ['Login', 'Password']
        results.each do |r|
          csv << r
        end
      end
    end

    def delete_quizzes
      Quiz.invalid.each { |q| q.destroy }
      true
    end
  end
end
