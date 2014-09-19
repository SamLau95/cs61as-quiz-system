require "spec_helper"

def fill_in_lesson
  select "1", from: "Lesson"
end

def fill_in_question
  fill_in "Question (parsed as Markdown)", with: "Lorem Ipsum"
end

def fill_in_solution
  fill_in "Solution (parsed as Markdown)", with: "Lorem Ipsum"
end

def fill_in_rubric
  fill_in "Rubric (parsed as Markdown)", with: "Lorem Ipsum"
end

def count_doesnt_change
  expect do
    click_button "Create"
  end.to change(Question, :count).by(0)
end

describe "Creating a question" do
  let(:staff) { create :staff }
  subject { page }
  before { sign_in staff }

  describe "through the question dashboard" do
    before do
      click_link "Questions"
      click_link "New Question!"
    end

    it "should not have a point field" do
      expect(page).to have_content "New Question!"
      expect(page).not_to have_content "Points"
    end

    # it "should return to question dashboard if you click cancel" do
    #   click_link "Cancel"
    #   expect(page).to have_content "Add a Question!"
    # end

    describe "should not be valid" do
      it "if lesson is blank" do
        fill_in_question
        fill_in_solution
        fill_in_rubric
      end

      it "if question is blank" do
        fill_in_lesson
        fill_in_solution
        fill_in_rubric
      end

      it "if solution is blank" do
        fill_in_lesson
        fill_in_question
        fill_in_rubric
      end

      it "if rubric is blank" do
        fill_in_lesson
        fill_in_question
        fill_in_solution
      end

      after do
        count_doesnt_change
        expect(page).to have_content "can't be blank"
      end
    end

    describe "should be valid" do
      it "if all information is filled in" do
        fill_in_lesson
        fill_in_question
        fill_in_solution
        fill_in_rubric
        expect do
          click_button "Create"
        end.to change(Question, :count).by 1
        expect(page).to have_content "Add a Question!"
      end
    end
  end
end
