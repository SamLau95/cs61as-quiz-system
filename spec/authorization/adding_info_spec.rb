require "spec_helper"

describe "Adding info for a new student" do
  let(:new_first) { 'New first' }
  let(:new_last) { 'New last' }
  let(:new_email) { 'new@email.com' }
  let(:new_pass) { 'newpassword' }
  let!(:student) { Student.create login: 'cs61as-aa', password: 'password' }
  subject { page }

  before do
    expect(student.added_info).to eql false
    sign_in student
    visit edit_user_path student
  end

  it { should have_content "Before you begin," }

  it "should not allow the student to access any other pages" do
    visit students_dashboard_path
    expect(page).to have_content "Before you begin,"
  end

  it "should not be valid  if no information is filled in" do

  end

  it "should allow student to access pages after filling in info" do
    fill_in_attributes
    fill_in 'Old Password', with: 'password'
    click_button "Update!"
    expect_attributes_to_be_updated student
    expect(page).to have_content "Welcome"
    expect(student.added_info).to eql true
  end
end
