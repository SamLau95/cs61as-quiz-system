# Other helpers
module ApplicationHelper
  def correct_type(type)
    type == 'MCQuestion' || type == 'CheckboxQuestion'
  end

  def types
    Question.subclasses
  end
end
