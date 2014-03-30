# == Schema Information
#
# Table name: options
#
#  id          :integer          not null, primary key
#  content     :text
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# List of options
class Option < ActiveRecord::Base
  belongs_to :question

  def self.get_options(options)
    options_list = []
    options.each { |op| options_list << [op.content, op.id] }
    options_list
  end
end
