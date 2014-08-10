require 'spec_helper'

describe "Someone that isn't signed in" do
  subject { page }

  describe 'can see the login page' do
    before { visit root_path }
    it { should have_content 'Sign in' }
  end

  describe 'cannot' do
    it 'see the staff dashboard' do
      visit student_dashboard_path
    end

    it 'see the staff dashboard' do
      visit staff_dashboard_path
    end

    it 'view any quizzes' do
      visit take_quizzes_path
    end

    after do
      expect(page).to have_content('Sign in')
    end
  end
end
