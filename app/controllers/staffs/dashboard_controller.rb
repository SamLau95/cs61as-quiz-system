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
                        .map { |login| import_staff login, "reader" }
      respond_to do |format|
        format.html { redirect_to import_staffs_students_path }
        format.csv do
          send_data create_staff_csv(@results),
                    filename: 'readers.csv'
        end
      end
    end

    def import_gsi
      @logins = params[:logins]
      @results = @logins.split
                        .reject { |login| Gsi.find_by_login login }
                        .map { |login| import_staff login, "gsi" }
      respond_to do |format|
        format.html { redirect_to import_staffs_students_path }
        format.csv do
          send_data create_staff_csv(@results),
                    filename: 'gsis.csv'
        end
      end
    end

    private

    def delete_invalid_quizzes
      Quiz.invalid.each { |q| q.destroy }
      true
    end

    def import_staff(login, type)
      password = Devise.friendly_token.first 8
      if
      staff = Rea
    end
  end
end
