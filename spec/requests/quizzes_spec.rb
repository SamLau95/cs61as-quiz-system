require 'spec_helper'

describe 'Making a quiz' do
  let(:staff) { create :staff }
  subject { quiz }
  before { sign_in staff }

  describe 'should increase quiz count' do
    before { visit staff_dashboard_path }

    it 'by one' do
      expect do
        click_link('Create a New Quiz!')
      end.to change(Quiz.all, :count).by(1)
    end
  end

  describe 'Editing Quizzes' do
    let!(:quiz) { create :quiz }
    before { visit staff_dashboard_path }
    subject { page }

    describe 'general editing tests' do

      it 'should go link to show page' do
        click_link(quiz)
        expect(page).to have_no_content('You have no questions yet!')
        expect(page).to have_link('Edit Quiz')
      end

      it 'should go to edit page when edit link is clicked' do
        visit quiz_path(quiz)
        click_link('Edit Quiz')
        expect(page).to have_content('Add a New Question!')
      end
    end

    describe 'Removing Questions' do
      before { visit edit_quiz_path(quiz) }
      subject { page }

      it 'should show no questions if one is removed' do
        expect(page).to have_content('Editing Quiz')
      end
    end
  end
end

