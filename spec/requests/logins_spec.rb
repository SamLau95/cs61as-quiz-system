require 'spec_helper'

describe 'Logging in' do
  subject { page }

  describe 'page' do
    before { visit root_path }
    it { should have_content 'Sign in' }
  end

  describe 'as a student' do
    let(:student) { create :student }
    before { sign_in student }

    it { should have_content 'Student' }
  end

  describe 'as staff' do
    let(:staff) { create :staff }
    before { sign_in staff }

    it { should have_content 'Staff' }
  end
end
