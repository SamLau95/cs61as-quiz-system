class StaffMailer < ActionMailer::Base
  default from: ENV["GMAIL_USERNAME"]

  def help_email(student, quizzes)
    @student = student
    @quizzes = quizzes
    Staff.each do |s|
      mail(to: s.email, subject: subject) unless s.email.blank?
    end
  end
end
