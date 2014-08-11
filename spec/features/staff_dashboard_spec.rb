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
end
