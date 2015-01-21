class ResetStaffJob
  include SuckerPunch::Job

  def perform
    Reader.all.each { |r| r.destroy }
    Gsi.all.each { |g| g.destroy }
  end
end
