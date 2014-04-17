# Pairs Questions and Submissions
class QuizSubmission
  attr_accessor :ques_subm

  def initialize(ques, sub)
    @ques_subm = []
    (0..sub.length - 1).each do |i|
      @ques_subm << [ques[i], sub[i]]
    end
  end
end
