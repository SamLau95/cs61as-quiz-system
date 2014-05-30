# == Schema Information
#
# Table name: taken_quizzes
#
#  id         :integer          not null, primary key
#  quiz_id    :integer
#  student_id :integer
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#

# TakenQuiz Class
class TakenQuiz < ActiveRecord::Base
  belongs_to :quiz
  belongs_to :student
end
