def make_users
  Student.create! first_name: 'Student',
                  last_name: "1",
                  email: "student#1@gmail.com",
                  password: 'password',
                  login: 'cs61as-aou'
  Staff.create! first_name: 'Staff',
                last_name: "1",
                email: "staff1@gmail.com",
                password: 'password',
                login: 'cs61as-av'
  Staff.create! first_name: "Staff",
                last_name: "2",
                email: "staff2@gmail.com",
                password: "password",
                login: "cs61as-ab"
end

def make_quizzes
  q = Quiz.create! lesson: '1',
                   version: 1,
                   is_draft: false
  q1 = Question.new content: 'What is 1 + 1?',
                        lesson: '1',
                        difficulty: 'Easy'
  q1.relationships.create! quiz_id: q.id,
                           question_id: q1.id,
                           number: 1,
                           points: 3
  q1.create_solution content: '2'
  q1.create_rubric rubric: '5: Hello'
  q2 = Question.create content: 'What is 1 * 3?',
                        lesson: '1',
                        difficulty: 'Medium'
  q2.relationships.create! quiz_id: q.id,
                           question_id: q2.id,
                           number: 2,
                           points: 3
  q2.create_solution content: '3'
  q2.create_rubric rubric: '5: Hello'
  q3 = Question.create! content: 'What is 10 + 1?',
                        lesson: '1',
                        difficulty: 'Hard'
  q3.relationships.create! quiz_id: q.id,
                           question_id: q3.id,
                           number: 3,
                           points: 4
  q3.create_solution content: '11'
  q3.create_rubric rubric: '5: Hello'
  q = Quiz.create! lesson: '2',
                   version: 1,
                   is_draft: false
  q4 = Question.create! content: 'What do you say after Hello?',
                        lesson: '2',
                        difficulty: 'Easy'
  q4.relationships.create! quiz_id: q.id,
                           question_id: q4.id,
                           number: 1,
                           points: 10
  q4.create_solution content: 'World'
  q4.create_rubric rubric: '5: Hello'
end

def make_requests
  Student.first.create_quiz_request lesson: 1
end

make_users
make_quizzes
make_requests
