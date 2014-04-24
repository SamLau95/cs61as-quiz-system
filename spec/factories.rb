FactoryGirl.define do
  factory :student do
    first_name 'Student'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "student#{n}@gmail.com" }
    password 'password'
  end

  factory :staff do
    first_name 'Staff'
    sequence(:last_name) { |n| "#{n}" }
    sequence(:email) { |n| "staff#{n}@gmail.com" }
    password 'password'
  end

  factory :quiz do
    sequence(:lesson) { |n| n }
    version 1
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

  factory :question do
    content Faker::Lorem.paragraph
    sequence(:number) { |n| n }
    points 5
    lesson 1
    difficulty 'Easy'
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
end
