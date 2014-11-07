# Student controller
module Staffs
  class StudentsController < BaseController
    def index
      @students = Student.valid_students.page params[:page]
      @value = params[:search]
      @search = Student.get params[:search]
    end

    def show
      @student = Student.find params[:id]
      @taken = TakenQuiz.sort_quizzes(@student.taken_quizzes).map do |q|
        Quiz.find(q.quiz_id)
      end
    end

    def import
      @results = []
    end

    def submit_import
      @logins = params[:logins]
      @results = @logins.split
                        .reject { |login| Student.find_by_login login }
                        .map { |login| import_student login }
      respond_to do |format|
        format.html { redirect_to import_staffs_students_path }
        format.csv do
          send_data create_student_csv(@results),
                    filename: 'studentInfo.csv'
        end
      end
    end

    def download_initial_passwords
      passwords = Student.all.map { |m| [m.login, m.first_password] }
      respond_to do |format|
        format.html { redirect_to staffs_dashboard_path }
        format.csv do
          send_data create_student_csv(passwords),
                    filename: 'studentInitialPW.csv'
        end
      end
    end

    private

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
  end
end
