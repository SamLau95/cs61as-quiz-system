require 'spec_helper'

describe 'The student dashboard' do
  let(:student) { create :student }
  before { sign_in student }
  subject { page }

  describe 'with quizzes' do
    before do
      create :quiz, lesson: 1, version: 1
      create :quiz, lesson: 1, version: 2
      create :quiz, lesson: 2
      visit students_dashboard_path
    end

    [1, 2].each do |lesson|
      it "has lesson #{lesson} as an option" do
        within 'select#lesson' do
          expect(page).to have_css "option[value=\"#{lesson}\"]"
        end
      end
    end
  end

  describe 'making a quiz request' do
    let!(:quiz) { create :quiz }
    before do
      visit students_dashboard_path
      select quiz.lesson, from: 'lesson'
    end

    it 'creates a QuizRequest' do
      expect { click_button 'Request' }
             .to change(QuizRequest, :count).by 1
    end
  end

  describe 'after making a request' do
    let!(:quiz) { create :quiz }
    before do
      visit students_dashboard_path
      select quiz.lesson, from: 'lesson'
      click_button 'Request'
    end

    it { should have_content 'requesting' }
    it { should have_content "#{quiz.lesson}" }
    it { should have_content 'not approved' }
    it { should_not have_link "Quiz #{quiz.lesson}" }

    describe 'before being approved' do
      before { visit take_students_quizzes_path }
      it 'does not allow a student to take a quiz' do
        expect(current_path).to eq students_dashboard_path
      end
    end

    describe 'approving' do
      it 'destroys the quiz request' do
        expect { student.quiz_request.lock_and_destroy! }
               .to change(QuizRequest, :count).by(-1)
      end

      it 'creates a quiz lock' do
        expect { student.quiz_request.lock_and_destroy! }
               .to change(QuizLock, :count).by 1
      end
    end

    describe 'after being approved' do
      before do
        student.quiz_request.lock_and_destroy!
        visit students_dashboard_path
      end

      it { should have_link 'Begin quiz!' }

      describe 'the begin quiz link' do
        before { click_link 'Begin quiz!' }
        it 'lets the student take a quiz' do
          expect(current_path).to eq take_students_quizzes_path
        end
      end
    end
  end

  describe 'taking a quiz' do
    let!(:quiz) { create :quiz }
    before do
      visit students_dashboard_path
      click_quiz_link quiz
      student.quiz_request.lock_and_destroy!
      visit students_dashboard_path
      click_link 'Begin quiz!'
    end
  end
end
