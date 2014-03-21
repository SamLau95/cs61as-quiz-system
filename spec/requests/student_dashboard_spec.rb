require 'spec_helper'

describe 'The student dashboard' do
  let(:student) { create :student }
  subject { page }

  describe 'displays all lessons' do
    before do
      create :quiz, lesson: 1, version: 1
      create :quiz, lesson: 1, version: 2
      create :quiz, lesson: 2
      sign_in student
    end

    [1, 2].each do |lesson|
      it { should have_content "Quiz #{lesson}" }
    end
  end

  describe 'making a quiz request' do
    let!(:quiz) { create :quiz }
    before { sign_in student }

    it { should have_content "Quiz #{quiz.lesson}" }
    it 'creates a QuizRequest' do
      expect { click_quiz_link quiz }
             .to change(QuizRequest, :count).by 1
    end
  end

  describe 'after making a request' do
    let!(:quiz) { create :quiz }
    before do
      sign_in student
      click_quiz_link quiz
    end

    it { should have_content 'requesting' }
    it { should have_content "#{quiz.lesson}" }
    it { should have_link 'Once a TA approves' }
    it { should_not have_content 'Take a quiz' }

    describe 'before being approved' do
      before { click_link 'Once a TA approves' }
      it { should have_content 'requesting' }
    end
  end
end
