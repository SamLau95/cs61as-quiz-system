require 'spec_helper'

describe 'Profile editing' do
  let(:new_first) { 'New first' }
  let(:new_last) { 'New last' }
  let(:new_email) { 'new@email.com' }
  let(:new_pass) { 'newpassword' }

  context 'as a Staff' do
    let(:staff) { create :staff, password: 'oldpassword' }
    subject { page }
    before do
      sign_in staff
      visit edit_user_path staff
    end

    it { should have_content 'Edit Profile' }

    context 'with info filled in' do
      before { fill_in_attributes }

      context 'with correct password' do
        before do
          fill_in 'Old Password', with: 'oldpassword'
          click_button 'Update!'
        end

        it 'updates attributes' do
          expect_attributes_to_be_updated staff
        end
      end
    end
  end

  context 'as a Student' do
    let(:student) { create :student, password: 'oldpassword' }
    subject { page }
    before do
      sign_in student
      visit edit_user_path student
    end

    it { should have_content 'Edit Profile' }

    context 'with info filled in' do
      before { fill_in_attributes }

      context 'with correct password' do
        before do
          fill_in 'Old Password', with: 'oldpassword'
          click_button 'Update!'
        end

        it 'updates attributes' do
          expect_attributes_to_be_updated student
        end
      end
    end
  end
end
