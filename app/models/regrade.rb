# == Schema Information
#
# Table name: regrades
#
#  id         :integer          not null, primary key
#  student_id :integer
#  quiz_id    :integer
#  graded     :boolean
#  created_at :datetime
#  updated_at :datetime
#

class Regrade < ActiveRecord::Base
end
