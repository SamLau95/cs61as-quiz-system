require 'spec_helper'

def fill_in_grade
  fill_in "Grade", with: 5
  fill_in "Comments", with: "Good Job!"
  click_button "Update Grade!"
end

def sign_out_and_in(user)
  sign_out
  sign_in user
end

describe "Regrading a Quiz" do
  subject { page }
  let(:staff) { create :staff }
  let!(:student) { create :student }
  let!(:quiz) { create :quiz_with_questions }
  let!(:taken_quiz) do
    TakenQuiz.create quiz: quiz,
                     student: student,
                     staff: staff,
                     lesson: quiz.lesson,
                     retake: quiz.retake,
                     grade: 15,
                     finished: true
  end

  before do
    quiz.questions.map do |q|
      create :submission, question: q, quiz: quiz, student: student
      create :grade, question: q, student: student
    end
  end

  describe "as a student" do
    before do
      sign_in student
      visit students_quiz_path(taken_quiz)
    end

    it { should have_content quiz.to_s }
    it { should have_content "Request a regrade!" }

    describe "making a request" do
      it "should be invalid if fields are blank" do
        expect { click_button "Submit!" }.to change(Regrade, :count).by 0
      end

      it "should be valid if the fields are filled in" do
        fill_in "Questions to Regrade", with: "1"
        fill_in "Reason why", with: "Just Because"
        expect { click_button "Submit!" }.to change(Regrade, :count).by 1
        expect(page).to have_content "Your quiz is being regraded!"
        expect(page).to_not have_content "Request a regrade!"
      end
    end

    describe "after making a request" do
      let!(:regrade) { create :regrade, student: student, quiz: quiz }
      before do
        taken_quiz.undo
        visit students_quiz_path(taken_quiz)
      end

      it { should have_content "Your quiz is being regraded!" }
      it { should_not have_content "Request a regrade!" }
      it { should_not have_content "Total:" }

      it "should not allow student to make another regrade request" do
        regrade.finish
        taken_quiz.finish
        visit students_quiz_path(taken_quiz)
        expect(page).to have_content "Total: 15.0/10"
        expect(page).to have_content "Your quiz has already been regraded!"
        expect(page).to_not have_content "Request a regrade!"
      end
    end
  end

  describe "as a staff member" do
    let!(:regrade) { create :regrade, student: student, quiz: quiz }
    before do
      sign_in staff
      taken_quiz.undo
      visit staffs_quiz_requests_path
    end

    it { should have_content regrade.to_s }
    it { should_not have_content "You don't have any regrade requests!" }

    describe "should not show up if it is deleted" do
      before do
        click_link "Delete Request!"
        visit staffs_quiz_requests_path
      end

      it { should have_content "You don't have any regrade requests!" }

      it "on the student quiz page" do
        sign_out_and_in student
        visit students_quiz_path(taken_quiz)
        expect(page).to have_content "Request a regrade!"
        expect(page).to have_content "Total:"
      end
    end

    describe "should take staff to quiz page" do
      before { click_link regrade.to_s }

      it { should have_content "Regrade request:" }
      it { should have_content "Questions to grade: #{regrade.questions}" }
      it { should have_content "Reasons: #{regrade.reason}" }

      describe "and be finished" do
        before do
          click_link "Finished Grading!"
        end

        it "and should not show up on requests page" do
          visit staffs_quiz_requests_path
          expect(page).to have_content "You don't have any regrade requests!"
        end

        it "and should not show up on student page anymore" do
          sign_out_and_in student
          visit students_quiz_path taken_quiz
          expect(page).to_not have_content "Request a regrade!"
          expect(page).to have_content "Total:"
          expect(page).to have_content "Your quiz has already been regraded!"
        end
      end
    end
  end
end
