require 'spec_helper'

describe 'The staff dashboard' do
  let(:staff) { create :staff, added_info: true }
  subject { page }
  before { sign_in staff }

  describe 'when there are quizzes' do
    let!(:quizzes) { create_pair :quiz }
    before { visit staff_dashboard_path }

    it 'displays all quizzes' do
      quizzes.each do |quiz|
        expect(page).to have_content quiz
      end
    end
  end

  # To move into a spec for quiz requests
  pending 'when there are quiz requests' do
    let!(:requests) { create_pair :quiz_request }
    before { visit staff_dashboard_path }

    it 'displays all unapproved quiz requests' do
      requests.each do |request|
        expect(page).to have_content request.to_s
      end
    end

    it 'displays confirm links' do
      requests.each do |request|
        expect(page).to have_link "approve-#{request.id}"
      end
    end

    it 'displays cancel links' do
      expect(page).to have_link 'Cancel'
    end
  end

  pending 'approving a request' do
    let!(:request) { create :quiz_request }
    before do
      visit staff_dashboard_path
      click_link "approve-#{request.id}"
    end

    it { should_not have_link "approve-#{request.id}" }
  end

  pending 'cancelling a request' do
    let!(:request) { create :quiz_request }
    before { visit staff_dashboard_path }

    it 'deletes the request' do
      expect { click_link "cancel-#{request.id}" }
             .to change(QuizRequest, :count).by(-1)
    end
  end
end
