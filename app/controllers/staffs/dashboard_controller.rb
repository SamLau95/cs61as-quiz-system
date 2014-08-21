# Controller for staff dashboard
module Staffs
  class DashboardController < BaseController
    before_action :delete_invalid_quizzes, only: :index

    def index
      @drafts = Quiz.sort_lesson Quiz.drafts
      @published = Quiz.sort_lesson Quiz.published
      @quiz = Quiz.new
      @download = Quiz::LESSON_VALUES.map { |n| ["Lesson #{n}", n] }
    end

    private

    def delete_invalid_quizzes
      Quiz.invalid.each { |q| q.destroy }
      true
    end
  end
end
