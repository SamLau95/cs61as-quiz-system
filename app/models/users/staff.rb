# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default("")
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
#  first_name             :string(255)
#  last_name              :string(255)
#  login                  :string(255)      default("")
#  added_info             :boolean          default(FALSE)
#  first_password         :string(255)      default("")
#

class Staff < User
  has_many :taken_quizzes

  def email_required?
    false
  end

  def staff?
    true
  end

  def gsi?
    false
  end

  def reader?
    false
  end

  def master?
    false
  end
end
