require 'spec_helper'

def expect_to_redirect_to_sign_in(path)
  visit path
  expect(page).to have_content 'Sign in'
end

describe "Someone that isn't signed in" do
  subject { page }

  describe 'can see the login page' do
    before { visit root_path }
    it { should have_content 'Sign in' }
  end

  describe 'cannot' do
    let (:user) { create :student }
    let (:quiz) { create :quiz }

    it 'see the student dashboard' do
      expect_to_redirect_to_sign_in students_dashboard_path
    end

    it 'see the staff dashboard' do
      expect_to_redirect_to_sign_in staffs_dashboard_path
    end

    it "edit a user's profile" do
      expect_to_redirect_to_sign_in edit_user_path(user)
    end

    it "take a quiz" do
      expect_to_redirect_to_sign_in take_students_quizzes_path
    end

    it 'see question bank' do
      expect_to_redirect_to_sign_in bank_staffs_questions_path
    end

    it 'see quiz stats' do
      expect_to_redirect_to_sign_in stats_staffs_quiz_path(quiz)
    end
  end
end
