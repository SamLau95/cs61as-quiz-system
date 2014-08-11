require 'spec_helper'

def fill_in_grade
  fill_in "Grade", with: 5
  fill_in "Comments", with: "Good Job!"
  click_button "Update Grade!"
end

describe "Grading a Quiz" do
  let(:staff) { create :staff }
  subject { page }
  before do
    sign_in staff
    visit grades_path
  end

  it { should have_content "Quizzes To Grade" }
  it { should have_content "You have no assignments." }
  it { should have_content "There are no quizzes to grade!"}

  describe "as a staff member" do
    let!(:student) { create :student }
    let!(:staff2) { create :staff }
    let!(:quiz) { create :quiz_with_questions }
    let!(:taken_quiz) { TakenQuiz.create(quiz_id: quiz.id,
                                        student_id: student.id,
                                        staff_id: staff2.id,
                                        lesson: quiz.lesson,
                                        retake: quiz.retake) }
    before do
      quiz.questions.map do |q|
        create :submission, question: q, quiz: quiz, student: student
      end
      visit grades_path
      expect(page).to_not have_content "There are no quizzes to grade!"
      expect(page).to have_content "You have no assignments."
      expect(page).to have_content "#{taken_quiz}"
      visit student_quiz_path(taken_quiz.student, taken_quiz.quiz)
    end

    describe "before grading quiz" do
      it { should have_content "#{quiz}" }
      it { should have_content "Total: 0.0/10"}
      it { should_not have_content "Finished Grading!" }
    end

    describe "grading a question" do
      before { first(:link, 'Grade Question!').click }

      it { should have_content "Grade Question" }

      describe "should not be valid" do

        it "if the grade is blank" do
          fill_in "Grade", with: ""
          click_button "Update Grade!"
          expect(page).to have_content "can't be blank"
        end

        it "if comments are blank" do
          fill_in "Comments", with: ""
          click_button "Update Grade!"
          expect(page).to have_content "can't be blank"
        end

        it "if the grade is not in range of (0..10)" do
          fill_in "Grade", with: 11
          click_button "Update Grade!"
          expect(page).to have_content "Invalid grade"
        end

        after do
          expect(page).to_not have_content "#{quiz}"
          expect(taken_quiz.grade).to eql(0.0)
        end
      end

      it "should increase total quiz grade if valid" do
        fill_in "Grade", with: 5
        fill_in "Comments", with: "Good Job!"
        click_button "Update Grade!"
        expect(page).to have_content "#{quiz}"
        expect(page).to have_content "Total: 5.0/10"
        expect(page).to have_content "5.0"
        expect(page).to have_content "Good Job!"
        expect(page).to_not have_content "Finished Grading!"
      end
    end

    describe "grading entire quiz" do
      before do
        quiz.questions.each do |q|
          page.find("#grade#{q.id}").click
          expect(page).to have_content "Grade Question"
          fill_in_grade
        end
      end

      it { should have_content "Total: 15.0/10" }
      it { should have_content "Finished Grading!" }
      it { should have_content "5.0" }
      it { should have_content "Good Job!" }

      it "should change taken_quiz's finished field to true" do
        click_link "Finished Grading!"
        expect(TakenQuiz.not_graded.count).to eq 0
      end

      it "should redirect to grading dashboard" do
        click_link "Finished Grading!"
        expect(page).to have_content "Quizzes To Grade"
        expect(page).to have_content "There are no quizzes to grade!"
        expect(page).to have_content "You have no assignments."
        expect(page).to_not have_content "#{taken_quiz}"
      end
    end
  end
end
