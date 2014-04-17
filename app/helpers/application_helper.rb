# Other helpers
module ApplicationHelper

  [MCQuestion, CodeboxQuestion, TextboxQuestion,
   CheckboxQuestion] if Rails.env == 'development'

  def correct_type(type)
    type == 'MCQuestion' || type == 'CheckboxQuestion'
  end

  def types
    Question.subclasses
  end

end
