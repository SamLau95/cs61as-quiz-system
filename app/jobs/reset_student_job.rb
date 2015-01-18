class ResetStudentJob
  include SuckerPunch::Job

  def perform
    Student.all.each { |s| s.destroy }
  end
end
