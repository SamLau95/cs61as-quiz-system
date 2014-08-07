require "spec_helper"

describe "Quiz" do
  let(:staff) { create :staff, added_info: true }
  subject { page }
  before { sign_in staff }


  describe "should increase quiz count" do
    before { visit staff_dashboard_path }

    it "by one" do
      expect do
        click_link("Create a New Quiz!")
      end.to change(Quiz, :count).by(1)
    end

    it "by -1 (removed invalid quizzes)" do
      expect do
        click_link("Create a New Quiz!")
        click_link("Dashboard")        
      end.to change(Quiz, :count).by(0)
    end
  end

  describe "should not be saved if invalid" do
    let!(:new_quiz) { create :quiz, lesson: "1", version: 1 }
    let!(:question) { create :question, lesson: "1"}
    before do 
      visit staff_dashboard_path
      click_link "Create a New Quiz!"
      expect(page).to have_content "Editing Quiz"
    end

    it "if it has an invalid version" do
      fill_in "Version", with: "a"
      click_button "Update!"
      expect(page).to have_content("is not a number")
    end

    it "if it has a version that has already been used" do
      fill_in "Version", with: 1
      select "1", from: "Lesson"
      click_button "Update!"
      expect(page).to have_content("This version has already been used!")      
    end

    it "if doesn't questions that add up to 10 points" do
      fill_in "Version", with: 2
      select "1", from: "Lesson"
      click_button "Update!"
      expect(page).to have_content("Points must sum to 10")      
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
      fill_in "Version", with: 2
      select "1", from: "Lesson"
      click_button "Update!"
      expect(page).to have_content "Question lessons must match" 
    end

    after do
      expect(page).to have_no_content("Welcome")      
    end
  end

  

  describe "editing" do
    let!(:quiz) { create :quiz }
    before { visit staff_dashboard_path }

    it "should go link to show page" do
      click_link(quiz)
      expect(page).to have_no_content("You have no questions yet!")
      expect(page).to have_link("Edit Quiz")
      expect(page).to have_link("Quiz Stats")
    end

    it "should go to edit page when edit link is clicked" do
      visit quiz_path(quiz)
      click_link("Edit Quiz")
      expect(page).to have_content("Add a new question!")
    end

    pending "removing questions" do
      before do
        create :question, quizzes: [quiz]
        visit edit_quiz_path(quiz)
      end

      it "should show no questions if one is removed" do
        click_link("delete")
        expect(page).to have_content("You have no questions yet!")
      end
    end
  end
end

