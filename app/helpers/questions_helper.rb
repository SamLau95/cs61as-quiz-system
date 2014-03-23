module QuestionsHelper
  def quiz_types
    [%w(Short\ Response textbox),
     %w(Multiple\ Choice multichoice),
     %w(Choose\ All checkbox),
     %w(Code codebox)]
  end
end
