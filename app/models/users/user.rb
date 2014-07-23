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
#

# Base User class; doesn't get instantiated
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  default_scope { order('login') }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  LOGRX = /\Acs61as-[a-z]{2,3}\z/
  validates :login, presence: true, format: { with: LOGRX }, uniqueness: true

  def staff?
    false
  end

  def student?
    false
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def taking_quiz?
    false
  end

  def has_info?
    !email.nil? && !first_name.nil? && !last_name.nil?
  end
end
