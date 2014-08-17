require 'spec_helper'

describe 'Staff dashboard requests' do
  let(:staff) { create :staff }
  let!(:request) { create :quiz_request }
  let!(:other_request) { create :quiz_request }

  subject { page }

  before do
    create :quiz, lesson: request.lesson
    create :quiz, lesson: other_request.lesson
    sign_in staff
    visit staffs_quiz_requests_path
  end

  it 'displays all unapproved quiz requests' do
    [request, other_request].each do |request|
      expect(page).to have_content request.to_s
    end
  end

  it 'displays confirm links' do
    [request, other_request].each do |request|
      expect(page).to have_link "approve-#{request.id}"
    end
  end

  it 'displays cancel links' do
    expect(page).to have_link 'Cancel'
  end

  describe 'approving a request' do
    it 'creates a QuizLock' do
      expect { click_link "approve-#{request.id}" }.to change(QuizLock, :count).by 1
    end

    it 'destroys the request' do
      expect { click_link "approve-#{request.id}" }.to change(QuizRequest, :count).by -1
    end
  end

  describe 'cancelling a request' do
    it 'deletes the request' do
      expect { click_link "cancel-#{request.id}" }
             .to change(QuizRequest, :count).by(-1)
    end
  end
end
