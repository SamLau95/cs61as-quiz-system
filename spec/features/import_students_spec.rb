require 'spec_helper'

describe 'Import students' do
  let(:staff) { create :staff }
  subject { page }

  before do
    sign_in staff
    visit import_staffs_students_path
  end

  it { should have_content 'Import Students' }

  describe "by filling in the import box with 2 students" do
    before do
      Student.destroy_all
      fill_in "import", with: "cs61as-aa \n cs61as-ab"
    end

    it "should increase the student count by 2" do
      expect { click_button "Create students!" }.to change(Student, :count).by 2
    end

    it "should have initial passwords" do
      click_button "Create students!"
      expect(
        Student.all.inject do |s1, s2|
          !s1.first_password.blank? && !s2.first_password.blank?
        end
      ).to eql true
    end
  end
end
