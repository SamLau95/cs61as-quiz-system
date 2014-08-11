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

# Base User class; doesn't get instantiated
class User < ActiveRecord::Base
  EMAIL_PATTERN = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  LOGIN_PATTERN = /\Acs61as-[a-z]{2,3}\z/

  default_scope { order('login') }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_save :set_added_info

  validates :first_name, :last_name, :email, presence: true, if: 'added_info?'
  validates :email, format: { with: EMAIL_PATTERN }, uniqueness: true, if: 'added_info?'
  validates :login, presence: true
  validates :login, format: { with: LOGIN_PATTERN }, uniqueness: true

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

  private

  def set_added_info
    self.added_info = email.present? && first_name.present? && last_name.present?
    true
  end
end
