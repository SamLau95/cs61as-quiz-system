require 'spec_helper'

describe 'Import students' do
  let(:staff) { create :staff }
  subject { page }

  before do
    sign_in staff
    visit import_staffs_students_path
  end

  it { should have_content 'Import Students' }
end
