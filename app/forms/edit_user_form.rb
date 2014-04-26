# Edit student
class EditUserForm < Reform::Form
  model :user

  property :first_name
  property :last_name
  property :email
  property :login
  property :password
  property :current_password
  property :password_confirmation

  validates :first_name, :last_name, :email, :login, presence: true
  validates :current_password, presence: true
  # validates :password, :password_confirmation, length: { minimum: 8 }
  validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_format_of :login, with: /cs61as-.{2,4}/

  def validate_and_save(user_params)
    validate(user_params)
  end
end
