require "spec_helper"

def fill_in_quiz_field(lesson, version)
  select lesson, from: "Lesson"
  fill_in "Version", with: version
  click_button "Update!"
end

describe "Quiz" do
  let(:staff) { create :staff }
  subject { page }
  before { sign_in staff }


  describe "should increase quiz count" do
    before { visit staffs_dashboard_path }

    it "by one" do
      expect do
        click_link("Create a New Quiz!")
      end.to change(Quiz, :count).by(1)
    end

    # it "by -1 (removed invalid quizzes)" do
    #   expect do
    #     click_link("Create a New Quiz!")
    #     click_link("Dashboard")
    #   end.to change(Quiz, :count).by(0)
    # end
  end

  describe "should not be valid" do
    before do
      Quiz.destroy_all
      Question.destroy_all
      visit staffs_dashboard_path
      click_link "Create a New Quiz!"
      expect(page).to have_content "Editing Quiz"
    end

    let!(:new_quiz_retake) { create :quiz, lesson: "1", version: 1, retake: true }
    let!(:question) { create :question, lesson: "1" }
    let!(:new_quiz_not_retake) { create :quiz, lesson: "1", version: 1, retake: false }

    it "if it has an invalid version" do
      fill_in_quiz_field "0-1", "a"
      expect(page).to have_content("is not a number")
      expect(page).to_not have_content("Welcome")
    end

    it "if it has a version that has already been used" do
      fill_in_quiz_field "1", 1
      expect(page).to have_content("This version has already been used!")
      expect(page).to_not have_content("Welcome")
    end

    it "if doesn't questions that add up to 10 points" do
      fill_in_quiz_field "1", 2
      expect(page).to have_content("Points must sum to 10")
      expect(page).to_not have_content("Welcome")
    end

    it "if question lessons don't match" do
      click_link "Add a new question!"
      expect(page).to have_content "New Question!"
      select "2", from: "Lesson"
      fill_in "Points", with: 10
      fill_in "Question (parsed as Markdown)", with: "Lorem Ipsum"
      fill_in "Solution (parsed as Markdown)", with: "Lorem Ipsum"
      fill_in "Rubric (parsed as Markdown)", with: "Lorem Ipsum"
      click_button "Create"
      expect(page).to have_content "Content: Lorem Ipsum"

      fill_in_quiz_field "1", 2
      expect(page).to have_content "Question lessons must match"
      expect(page).to_not have_content "Welcome"
    end

    it "if it uses a question that has already been used by a retake" do
      new_quiz_retake.relationships.create! question_id: question.id,
                                     number: 1,
                                     points: 10
      click_link "Lesson 1"
      expect(page).to have_content question.content.truncate 100
      click_link "Add question!"
      expect(page).to have_content "Editing Quiz"
      expect(page).to have_content question.content
      click_link "Edit Question"
      fill_in "Points", with: 10
      click_button "Update"
      fill_in_quiz_field "1", 2
      expect(page).to_not have_content "Welcome"
      expect(page).to have_content "You have an invalid question!"
    end
  end



  describe "editing" do
    let!(:quiz) { create :quiz }
    before { visit staffs_dashboard_path }

    it "should go link to show page" do
      click_link(quiz)
      expect(page).to have_no_content("You have no questions yet!")
      expect(page).to have_link("Edit Quiz")
      expect(page).to have_link("Quiz Stats")
    end

    it "should go to edit page when edit link is clicked" do
      visit staffs_quiz_path(quiz)
      click_link("Edit Quiz")
      expect(page).to have_content("Add a new question!")
    end

    describe "removing questions", js: true do
      before do
        create :question, quizzes: [quiz]
        page.evaluate_script('window.confirm = function() { return true; }')
        visit edit_staffs_quiz_path(quiz)
      end

      it "should not allow removal if quiz is published" do
        click_link "Remove"
        expect(page).to have_content "Can't remove"
      end

      it "should remove question if quiz is published" do
        quiz.toggle! :is_draft
        click_link "Remove"
        expect(page).to have_content "You have no questions yet!"
      end
    end
  end

  describe "stats" do
    let(:quiz) { create :quiz_with_questions }
    before { visit stats_staffs_quiz_path(quiz) }

    it { should have_content quiz.to_s }

    describe "should be zero if there are no quizzes" do
      it { should have_content "Average grade: 0" }
    end

    describe "should be >= zero if there are quizzes" do
      let(:student) { create :student }
      let!(:taken_quiz) { create :taken_quiz, quiz: quiz, student: student, grade: 5.0, finished: true }
      before do
        print taken_quiz
        visit stats_staffs_quiz_path(quiz)
      end

      it { should have_content student.name }
      it { should have_content student.login }
      it { should have_content "Average grade: 5.0" }
    end
  end
end

