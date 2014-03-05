# == Schema Information
#
# Table name: quiz_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  quiz_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class QuizRequest < ActiveRecord::Base
end
