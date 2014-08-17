# Creates a Question
class CreateQuestion
  def self.call(question_params)
    solution = Solution.new question_params.delete :solution_attributes
    rubric = Rubric.new question_params.delete :rubric_attributes
    question = Question.new question_params
    question.solution = solution
    question.rubric = rubric
    question
  end
end
