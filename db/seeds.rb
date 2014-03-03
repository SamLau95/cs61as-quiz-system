
def make_users
  1.upto(2) do |i|
    Student.create! email: "student#{i}@gmail.com",
                    password: 'password'
    Staff.create! email: "staff#{i}@gmail.com",
                  password: 'password'
  end
end

make_users