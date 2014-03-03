
def make_users
  1.upto(2) do |i|
    Student.create! email: "student#{i}@gmail.com",
                    password: 'password'
    Staff.create! email: "staff#{i}@gmail.com",
                  password: 'password'
  end
end

def make_quizzes
  q = Quiz.create! lesson: 1,
                   version: 1
  q1 = q.questions.create! number: 1,
                           points: 2,
                           content: 'What is 1 + 1?'
  q1.create_solution content: '2'
  q2 = q.questions.create! number: 2,
                           points: 3,
                           content: 'What is 1 * 1?'
  q2.create_solution content: '1'
  q3 = q.questions.create! number: 3,
                           points: 5,
                           content: 'What is 10 + 1?'
  q3.create_solution content: '11'
end

make_users
make_quizzes