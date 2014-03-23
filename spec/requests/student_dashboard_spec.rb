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
    it { should have_content 'not approved' }
    it { should_not have_link "Quiz #{quiz.lesson}" }

    describe 'before being approved' do
      before { visit take_quiz_path }
      it 'does not allow a student to take a quiz' do
        expect(current_path).to eq student_dashboard_path
      end
    end

    describe 'after being approved' do
      before do
        student.quiz_request.approve!
        visit student_dashboard_path
      end

      it { should have_link 'Begin quiz!' }

      describe 'the begin quiz link' do
        before { click_link 'Begin quiz!' }
        it 'lets the student take a quiz' do
          expect(current_path).to eq take_quiz_path
        end
      end
    end
  end
end
