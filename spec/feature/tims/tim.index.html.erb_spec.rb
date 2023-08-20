require 'rails_helper'

RSpec.describe '/tims', type: :feature do
  before(:each) do
    create(:tim, nama_tim: 'Tim Kota', jenis: 'Kota', tahun: '2023')
    create(:tim, nama_tim: 'Tim Kota 2', jenis: 'Kota', tahun: '2023')
  end

  it "render list of tims" do
    user = create(:super_admin)

    login_as user
    visit tims_path

    expect(page).to have_title('Daftar Tim')
    expect(page).to have_content('Tim Kota')
    expect(page).to have_content('Tim Kota 2')
  end
end
