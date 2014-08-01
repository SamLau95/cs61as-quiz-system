require 'spec_helper'

describe Quiz do
  let!(:quiz1) { create :quiz_with_questions, lesson: 1 }
  let!(:quiz2) { create :quiz, lesson: 2 }
  let!(:request1) { create :quiz_request, lesson: '1', retake: false }
  describe '.lessons' do
    it 'should return an array of published lessons' do
      expect(Quiz.lessons).to eq(['1', '2'])
    end
  end

  describe '.choose_one' do
    let(:chosen_quiz) { Quiz.choose_one(request1) }
    it 'should choose a random quiz' do
      expect(chosen_quiz.lesson).to eq(request1.lesson)
      expect(chosen_quiz.retake).to eq(request1.retake) 
    end
  end

  describe '.to_s' do
    it "should return the Quiz lesson and version" do
      expect(quiz1.to_s).to eq("Quiz 1a#{quiz1.version}")
      expect(quiz2.to_s).to eq("Quiz 2a#{quiz2.version}")
    end
  end

  describe '#new_submissions' do
    it 'should create new submissions' do
      expect(quiz1.questions.length).to eq(3)
      expect(quiz1.new_submissions.length)
            .to eq(3)

      expect(quiz2.questions.length).to eq(0)
      expect(quiz2.new_submissions.length).to eq(0)
    end
  end

  describe '#next_number' do

    it 'should return the question number for the quiz' do
      pending('implement later')
      expect(quiz1.questions.length).to equal(3)
      expect(quiz1.next_number).to equal(3)

      expect(quiz2.questions.length).to equal(0)
      expect(quiz2.next_number).to equal(0)
    end
  end
  
end
