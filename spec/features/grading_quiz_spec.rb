require 'spec_helper'

describe "Grading a Quiz" do
  let(:staff) { create :staff }
  subject { page }
  before do
    sign_in staff
    visit grades_path
  end

  it { should have_content "Quizzes To Grade" }
  it { should have_content "You have no assignments." }


  describe "" do

  end
end
