# Controller for QuizLocks
class QuizLocksController < ApplicationController
  load_and_authorize_resource

  def lock
    quiz_lock = QuizLock.find params[:id]
    quiz_lock.lock!
    respond_to do |format|
      format.js
    end
  end
end
