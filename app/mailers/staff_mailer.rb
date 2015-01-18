class StaffMailer < ActionMailer::Base
  default from: ENV["GMAIL_USERNAME"]

  def help_email(student, quizzes)
    @student = student
    @quizzes = quizzes
    mail(to: "contact.elevate.africa@gmail.com", subject: subject)
  end
end
