class HelpEmailJob
  include SuckerPunch::Job

  def perform(student, quizzes)
    ::StaffMailer.help_email(student, quizzes).deliver
  end
end
