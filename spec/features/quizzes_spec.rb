require 'spec_helper'

describe 'Quiz' do
  let(:staff) { create :staff, added_info: true }
  subject { page }
  before { sign_in staff }


  describe 'should increase quiz count' do
    before { visit staff_dashboard_path }

    it 'by one' do
      expect do
        click_link('Create a New Quiz!')
      end.to change(Quiz.all, :count).by(1)
    end
  end

  describe 'editing' do
    let!(:quiz) { create :quiz }
    before { visit staff_dashboard_path }

    it 'should go link to show page' do
      click_link(quiz)
      expect(page).to have_no_content('You have no questions yet!')
      expect(page).to have_link('Edit Quiz')
    end

    it 'should go to edit page when edit link is clicked' do
      visit quiz_path(quiz)
      click_link('Edit Quiz')
      expect(page).to have_content('Add a new question!')
    end

    pending 'removing questions' do
      before do
        create :question, quizzes: [quiz]
        visit edit_quiz_path(quiz)
      end

      it 'should show no questions if one is removed' do
        click_link('delete')
        expect(page).to have_content('You have no questions yet!')
      end
    end
  end
end

