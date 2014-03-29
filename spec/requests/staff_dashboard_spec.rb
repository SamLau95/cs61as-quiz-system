require 'spec_helper'

describe 'The staff dashboard' do
  let(:staff) { create :staff }
  subject { page }
  before { sign_in staff }

  describe 'when there are quizzes' do
    let!(:quizzes) { 4.times.map { create :quiz } }
    before { visit staff_dashboard_path }

    it 'displays all quizzes' do
      quizzes.each do |quiz|
        expect(page).to have_content quiz
      end
    end
  end

  describe 'when there are quiz requests' do
    let!(:requests) { 4.times.map { create :quiz_request } }
    let!(:approved_request) { create :quiz_request, approved: true }
    before { visit staff_dashboard_path }

    it 'displays all unapproved quiz requests' do
      requests.each do |request|
        expect(page).to have_content request.to_s
      end
    end

    it 'does not show approved requests' do
      expect(page).not_to have_content approved_request.to_s
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

  describe 'approving a request' do
    let!(:request) { create :quiz_request }
    before do
      visit staff_dashboard_path
      click_link "approve-#{request.id}"
    end

    it { should_not have_link "approve-#{request.id}" }
  end

  describe 'cancelling a request' do
    let!(:request) { create :quiz_request }
    before { visit staff_dashboard_path }

    it 'deletes the request' do
      expect { click_link "cancel-#{request.id}" }
             .to change(QuizRequest, :count).by(-1)
    end
  end
end
