# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  lesson     :string(255)      default("")
#  version    :integer          default(0)
#  retake     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#  is_draft   :boolean          default(TRUE)
#

require "spec_helper"

describe Quiz do
  let!(:quiz1) { create :quiz_with_questions, lesson: "1" }
  let!(:quiz2) { create :quiz, lesson: "2" }
  let!(:request1) { create :quiz_request, lesson: "1", retake: false }

  let!(:question1) { create :question, difficulty: "Easy", lesson:  "2" }
  let!(:question2) { create :question, difficulty: "Medium", lesson: "2" }
  let!(:question3) { create :question, difficulty: "Hard", lesson: "2" }

  describe ".lessons" do
    it "should return an array of published lessons" do
      expect(Quiz.lessons).to eq(["1", "2"])
    end
  end

  describe ".choose_one" do
    let(:chosen_quiz) { Quiz.choose_one(request1) }
    it "should choose a random quiz" do
      expect(chosen_quiz.lesson).to eq(request1.lesson)
      expect(chosen_quiz.retake).to eq(request1.retake)
    end
  end

  describe ".to_s" do
    it "should return the Quiz lesson and version" do
      expect(quiz1.to_s).to eq("Quiz 1a#{quiz1.version}")
      expect(quiz2.to_s).to eq("Quiz 2a#{quiz2.version}")
    end
  end

  describe "#new_submissions" do
    it "should create new submissions" do
      expect(quiz1.questions.length).to eq(3)
      expect(quiz1.new_submissions.length)
            .to eq(3)

      expect(quiz2.questions.length).to eq(0)
      expect(quiz2.new_submissions.length).to eq(0)
    end
  end

  describe "#next_number" do
    it "should return the question number for the quiz" do
      pending("implement later")
      expect(quiz1.questions.length).to equal(3)
      expect(quiz1.next_number).to equal(3)

      expect(quiz2.questions.length).to equal(0)
      expect(quiz2.next_number).to equal(0)
    end
  end

  describe ".generate_random" do
    let!(:generated_quiz) { Quiz.generate_random("2", false) }
    it "should generate a quiz with 3 random questions (if possible)" do
      [question1, question2, question3].each do |question|
        expect(generated_quiz.questions.to_a).to include(question)
      end
    end
  end

  describe "#get_quest" do
    let!(:questions_array) { quiz2.get_quest(quiz2.lesson) }
    it "should get an array of questions from the same lesson" do
      expect(questions_array.length).to equal(3)
      [question1, question2, question3].each do |question|
        expect(questions_array).to include(question)
      end
    end
  end

  describe "#add_numbers" do
    let!(:generated_quiz) { Quiz.generate_random("2", false) }
    let!(:quiz_numbers) { generated_quiz.relationships.map {|q| q.number } }
    it "should add numbering to questions" do
      expect(quiz_numbers).to eql([1,2,3])
    end
  end

  describe "#can_add?" do
    let!(:quiz3) { create :quiz, lesson: "2", retake: true }
    before do
      quiz3.questions << question1
      quiz2.questions << question2
    end
    it "should detect whether or not a question can be added to a quiz" do
      expect(quiz2.can_add?(question1)).to be false
      expect(quiz3.can_add?(question2)).to be false

      expect(quiz2.can_add?(question3)).to be true
      expect(quiz3.can_add?(question3)).to be true
    end
  end

  describe ".has_quiz" do
    it "should return boolean if there is a quiz with given lesson/retake" do
      expect(Quiz.has_quiz(quiz1.lesson, quiz1.retake)).to be true
      expect(Quiz.has_quiz(quiz1.lesson, !quiz1.retake)).to be false
    end
  end

  describe ".sort_lesson" do
    before do
      Quiz.destroy_all
      ["0-1", "0-2", "0-3", "10"].each do |lesson|
        Quiz.create(lesson: lesson)
      end
    end
    let!(:sorted) { ["0-1", "0-2", "0-3", "10"] }
    let!(:lessons) { Quiz.sort_lesson(Quiz.all, Quiz::LESSON_VALUES).map { |q| q.lesson } }
    it "should return a sorted array of Quizzes" do
      expect(lessons).to eql(sorted)
    end
  end
end
