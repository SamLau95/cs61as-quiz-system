# Controller for staff dashboard
module Staffs
  class DashboardController < ApplicationController
    load_and_authorize_resource class: false
    before_action :delete_invalid_quizzes, only: :index

    def index
      @drafts = Quiz.sort_lesson Quiz.drafts
      @published = Quiz.sort_lesson Quiz.published
      @quiz = Quiz.new
      @download = downloads
    end

    private

    def downloads
      download = []
      Quiz::LESSON_VALUES.each do |n|
        download << ["Lesson #{n}", n]
      end
      download
    end

    def delete_invalid_quizzes
      Quiz.invalid.each { |q| q.destroy }
      true
    end
  end
end
