require 'spec_helper'

describe 'The staff dashboard' do
  let(:staff) { create :staff }
  subject { page }

  describe 'when there are quizzes' do
    let!(:quizzes) { 4.times.map { create :quiz } }
    before { sign_in staff }

    it 'displays all quizzes' do
      quizzes.each do |quiz|
        expect(page).to have_content quiz
      end
    end
  end

  describe 'when there are quiz requests' do
    let!(:quiz_requests) { 4.times.map { create :quiz_request } }
    before { sign_in staff }

    it 'displays all quiz requests' do
      quiz_requests.each do |request|
        expect(page).to have_content request.to_s
      end
    end
  end
end
