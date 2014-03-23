# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  type                   :string(255)
#  first_name             :text
#  last_name              :text
#

# Student model; uses users table
class Student < User
  has_many :submissions
  has_one :quiz_request

  delegate :lesson, to: :quiz_request, prefix: true

  def approved_request?
    quiz_request && quiz_request.approved?
  end

  def student?
    true
  end
end
