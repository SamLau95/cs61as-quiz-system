# Controller for staff dashboard
module Staffs
  class DashboardController < BaseController

    def index
      @drafts = Quiz.sort_lesson Quiz.drafts, Quiz::DRAFT_LESSON_VALUES
      @published = Quiz.sort_lesson Quiz.published, Quiz::LESSON_VALUES
      @quiz = Quiz.new
      @download = Quiz::LESSON_VALUES.map { |n| ["Lesson #{n}", n] }
    end

    def import
      @results = []
    end

    def import_reader
      @logins = params[:logins]
      @results = @logins.split
                        .reject { |login| Reader.find_by_login login }
                        .map { |login| import_staff login, Reader.new }
      respond_to do |format|
        format.html { redirect_to import_staffs_dashboard_index_path }
        format.csv do
          send_data User.create_csv(@results),
                    filename: 'readers.csv'
        end
      end
    end

    def import_gsi
      @logins = params[:logins]
      @results = @logins.split
                        .reject { |login| Gsi.find_by_login login }
                        .map { |login| import_staff login, Gsi.new }
      respond_to do |format|
        format.html { redirect_to import_staffs_dashboard_index_path }
        format.csv do
          send_data User.create_csv(@results),
                    filename: 'TAs.csv'
        end
      end
    end

    def get_passwords
      reader_passwords = Staff.all.map { |s| [s.login, s.first_password] }
      ta_passwords = Gsi.all.map { |s| [s.login, s.first_password] }
      passwords = reader_passwords + ta_passwords
      respond_to do |format|
        format.html { redirect_to import_staffs_dashboard_index_path }
        format.csv do
          send_data User.create_csv(passwords),
                    filename: "staff_initial_passwords.csv"
        end
      end
    end

    def destroy_students
      Student.all.each { |s| s.destroy }
      flash[:success] = "Reset student database!"
      redirect_to import_staffs_dashboard_index_path
    end

    def destroy_staff
      Staff.all.each { |s| s.destroy if !s.master? }
      flash[:success] = "Reset staff members!"
      redirect_to import_staffs_dashboard_index_path
    end

    private

    def delete_invalid_quizzes
      Quiz.invalid.each { |q| q.destroy }
      true
    end

    def import_staff(login, staff)
      password = Devise.friendly_token.first 8
      staff.update_attributes({ password: password, first_password: password, login: login })
      if staff.new_record?
        [login, "Not saved. #{staff.errors.full_messages.join ' '}"]
      else
        [login, password]
      end
    end
  end
end
