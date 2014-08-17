require 'spec_helper'

describe 'Logging in' do
  subject { page }

  describe 'page' do
    before { visit root_path }
    it { should have_content 'Sign in' }
  end

  describe 'as a student' do
    let(:student) { create :student, first_name: nil }

    describe 'without filling in profile' do
      before { sign_in student }
      it 'prompts to complete it' do
        expect(current_path).to eq(edit_user_path student)
      end
    end

    describe 'with info filled in' do
      before do
        student.update first_name: 'Hello'
        sign_in student
      end

      it 'goes to student dashboard' do
        expect(current_path).to eq(students_dashboard_path)
      end
    end
  end

  describe 'as staff' do
    let(:staff) { create :staff, first_name: nil }

    describe 'without filling in profile' do
      before { sign_in staff }
      it 'prompts to complete it' do
        expect(current_path).to eq(edit_user_path staff)
      end
    end

    describe 'with info filled in' do
      before do
        staff.update first_name: 'Hello'
        sign_in staff
      end

      it 'goes to staff dashboard' do
        expect(current_path).to eq(staffs_dashboard_path)
      end
    end
  end
end
