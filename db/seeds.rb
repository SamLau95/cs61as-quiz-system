
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
                           content: 'What is 1 + 1?'
  q1.create_solution content: '2'
end

make_users