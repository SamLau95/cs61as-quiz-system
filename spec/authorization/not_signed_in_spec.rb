require 'spec_helper'

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
      visit student_dashboard_path
    end

    it 'see the staff dashboard' do
      visit staff_dashboard_path
    end

    it 'view any quizzes' do
      visit take_quizzes_path
    end

    it "edit a user's profile" do
      visit edit_user_path(user)
    end

    it "take a quiz" do
      visit take_quizzes_path
    end

    it 'see question bank' do
      visit bank_questions_path
    end

    it 'see quiz stats' do
      visit stats_quiz_path(quiz)
    end

    after do
      expect(page).to have_content('Sign in')
    end
  end
end
