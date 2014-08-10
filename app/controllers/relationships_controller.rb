class RelationshipsController < ApplicationController
  def destroy
    quiz = Quiz.find params[:quiz_id]
    if quiz.is_draft?
      Relationship.find_by(quiz: quiz, question_id: params[:question_id]).destroy
      flash[:success] = "Removed question from quiz."
    else
      flash[:error] = "Can't remove question from published quiz!"
    end
    redirect_to edit_quiz_path quiz
  end
end
