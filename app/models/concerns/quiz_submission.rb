# Pairs Questions and Submissions
class QuizSubmission
  attr_accessor :ques_subm

  def initialize(ques, sub, score)
    @ques_subm = []
    (0..sub.length - 1).each do |i|
      s = sub[i]
      r = Relationship.find_by(question_id: s.question_id,
                               quiz_id: s.quiz_id)
      @ques_subm << [ques[i], s, score[i], r]
    end
  end
end
