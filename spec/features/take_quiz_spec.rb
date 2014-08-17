require "spec_helper"

def textarea_name(id)
  "quiz[new_submissions_attributes][#{id}][content]"
end

def textarea_css(id)
  "textarea[name='#{textarea_name(id)}']"
end

def expect_quiz_to_be_submitted
  expect(Submission.count).to eq(3)
  expect(QuizLock.count).to eq(0)
  expect(TakenQuiz.count).to eq(1)
end

describe "Taking a quiz" do
  let!(:quiz) { create :quiz_with_questions }
  let!(:student) { create :student }
  let!(:staff) { create :staff }
  let!(:quiz_lock) { create :quiz_lock, student: student, quiz: quiz }

  before { sign_in student }
  subject { page }

  it "that has three questions" do
    expect(quiz.questions.length).to eq(3)
  end

  it { should have_link "Begin" }

  describe "beginning quiz", js: true do
    before { click_link "Begin" }

    it { should have_content "Quiz #{quiz.lesson}" }
    it { should have_link "Start" }

    describe "clicking start" do
      before { click_link "Start" }

      it "shows questions" do
        quiz.questions.each do |question|
          expect(page).to have_content question.content
        end
      end

      it "shows textareas" do
        0.upto(2) do |n|
          expect(page).to have_css textarea_css(n), visible: false
        end
      end

      context "when time runs out" do
        before do
          quiz_lock.created_at = 1.hour.ago + 5.seconds
          quiz_lock.save
          visit take_students_quizzes_path
          sleep 3
        end

        it "submits the quiz" do
          expect(page).to have_content "Student Dashboard"
          expect_quiz_to_be_submitted
        end
      end

      context "when focus is lost" do
        before do
          page.execute_script "$(window).blur()"
          sleep 0.5
          visit students_dashboard_path
        end

        it "locks the quiz" do
          expect(quiz_lock.reload).to be_locked
        end

        it "shows the staff login page" do
          expect(page).to have_content "screen change"
        end

        describe "filling in right staff info" do
          before do
            fill_in "Staff Login", with: staff.login
            fill_in "Password", with: staff.password
            click_button "Unlock"
          end

          it "unlocks and goes back to quiz taking" do
            expect(quiz_lock.reload).not_to be_locked
            expect(page).to have_link "Start!"
          end
        end

        describe "filling in wrong info" do
          before do
            fill_in "Staff Login", with: student.login
            fill_in "Password", with: student.password
            click_button "Unlock"
          end

          it "is still locked" do
            expect(quiz_lock.reload).to be_locked
            expect(page).to have_content "screen change"
          end
        end
      end

      context "filling in answers" do
        before do
          0.upto(2) do |n|
            page.execute_script("$(\"#{textarea_css(n)}\")[0].value = 'Answer #{n}'")
          end
        end

        it "and submitting creates Submissions and a TakenQuiz and destroys the QuizLock" do
          expect(Submission.count).to eq(0)
          expect(QuizLock.count).to eq(1)
          expect(TakenQuiz.count).to eq(0)
          click_button "Submit!"
          expect_quiz_to_be_submitted
        end

        describe "and submitting" do
          before { click_button "Submit!" }

          it "assigns the quiz to a staff member" do
            taken_quiz = TakenQuiz.find_by student: student
            expect(taken_quiz.staff).to be_present
          end

          it "redirects to dashboard" do
            expect(page).to have_content "Student Dashboard"
            expect(page).to have_link quiz.to_s
          end
        end
      end
    end
  end
end
