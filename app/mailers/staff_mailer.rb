class StaffMailer < ActionMailer::Base
  default from: ENV["GMAIL_USERNAME"]

  def help_email(student, quizzes)
    @student = student
    @quizzes = quizzes
    Reader.all.each do |s|
      mail to: s.email, subject: "61AS Student report for #{student.name}" unless s.email.blank?
    end
  end
end
