require 'spec_helper'

describe "Someone that isn't signed in" do
  subject { page }

  describe 'can see the login page' do
    before { visit root_path }
    it { should have_content 'Sign in' }
  end

  describe 'cannot see the student dashboard' do
    before { visit student_dashboard_path }
    it { should have_content 'Sign in' }
  end

  describe 'cannot see the student dashboard' do
    before { visit staff_dashboard_path }
    it { should have_content 'Sign in' }
  end

  describe 'cannot view any quizzes' do
    before { visit take_quiz_path }
    it { should have_content 'Sign in' }
  end

end
