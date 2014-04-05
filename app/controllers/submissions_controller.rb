# Submissions controller
class SubmissionsController < ApplicationController

  def show
    @submissions = Submissions.where quiz_id: params[:id]
  end
end
