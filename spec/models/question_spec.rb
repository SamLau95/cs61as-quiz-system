# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  content    :text
#  number     :integer
#  quiz_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Question do
  pending "add some examples to (or delete) #{__FILE__}"
end
