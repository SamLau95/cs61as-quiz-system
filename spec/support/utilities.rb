include ApplicationHelper

def sign_in(user)
  visit root_path
  fill_in 'Login', with: user.login
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def sign_out
  visit root_path
  click_link 'Sign Out'
end

def fill_in_attributes
  fill_in 'First name',        with: new_first
  fill_in 'Last name',         with: new_last
  fill_in 'Email',        with: new_email
  fill_in 'New Password', with: new_pass
  fill_in 'Confirm',      with: new_pass
end

def expect_attributes_to_be_updated(user)
  user.reload
  expect(user.first_name).to eq new_first
  expect(user.last_name).to eq new_last
  expect(user.email).to eq new_email
  expect(user.valid_password? new_pass).to be_true
end
