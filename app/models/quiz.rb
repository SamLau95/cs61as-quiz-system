# == Schema Information
#
# Table name: quizzes
#
#  id         :integer          not null, primary key
#  lesson     :integer
#  version    :integer
#  retake     :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

class Quiz < ActiveRecord::Base
  has_many :questions
end
