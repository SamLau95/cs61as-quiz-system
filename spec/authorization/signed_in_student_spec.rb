require 'spec_helper'

describe 'a signed in student' do
  let(:student) { create :student }
  before { sign_in student }

  subject { page }

  it { should have_content 'Student Dashboard' }

  describe 'cannot' do
    describe 'edit quizzes' do
      let(:quiz) { create :quiz }
      before { visit edit_quiz_path quiz }

      it { should_not have_content 'Editing' }
      it { should have_content 'Student' }
    end

    describe 'view staff dashboard' do
      before { staff_dashboard_path }
      it { should_not have_content 'Staff' }
      it { should have_content 'Student' }
    end

    describe 'take quiz without making request' do
      before { visit take_quiz_path }
      it { should_not have_content '#take_quiz_form' }
      it { should have_content 'Student' }
    end
  end

  describe 'can' do
    describe 'make a request' do
      let!(:quiz) { create :quiz }
      before do
        visit student_dashboard_path
        click_quiz_link quiz
      end

      it { should have_content 'requesting' }
    end
  end
end
