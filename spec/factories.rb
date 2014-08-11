FactoryGirl.define do
  logins = ('aa'..'zz').to_a

  factory :student do
    first_name 'Student'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "student#{n}@gmail.com" }
    sequence(:login) { |n| "cs61as-a#{logins[n]}" }
    password 'password'
    added_info true
  end

  factory :staff do
    first_name 'Staff'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "staff#{n}@gmail.com" }
    sequence(:login) { |n| "cs61as-t#{logins[n]}" }
    password 'password'
    added_info true
  end

  factory :quiz do
    lesson '1'
    sequence(:version) { |n| n }
    retake false
    is_draft false

    factory :quiz_with_questions do
      ignore { questions_count 3 }

      after(:create) do |quiz, evaluator|
        evaluator.questions_count.times do |n|
          quiz.questions << create(:question)
        end
      end
    end
  end

  factory :rubric do
    rubric { Faker::Lorem.paragraph }
    question
  end

  factory :solution do
    content { Faker::Lorem.paragraph }
    question
  end

  factory :question do
    content { Faker::Lorem.paragraph }
    lesson '1'
    difficulty 'Easy'

    after(:build) do |question|
      question.solution = create :solution, question: question unless question.solution
      question.rubric = create :rubric, question: question unless question.rubric
    end
  end

  factory :quiz_request do
    sequence(:lesson) { |n| n }
    student
  end

  factory :quiz_lock do
    locked false
    student
    quiz
  end

  factory :submission do
    content { Faker::Lorem.paragraph }
    student
    quiz
    question
  end

  factory :taken_quiz do
    staff
    student
  end
end
