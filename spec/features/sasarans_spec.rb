require 'rails_helper'

RSpec.describe "Sasarans", type: :feature do
  let(:user) { create(:eselon_4) }

  before(:each) do
    login_as user

    # setup cookies
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2023')
  end

  scenario "new sasaran with pohon kinerja on top", js: true do
    visit new_sasaran_path(tipe: user.eselon_user)
    fill_in 'sasaran[sasaran_kinerja]', with: 'Test Rencana Kinerja'
    fill_in 'Indikator kinerja', with: 'Indikator'
    fill_in 'Target', with: '100'
    fill_in 'Satuan', with: '%'
    click_on 'Simpan'
    expect(page).to have_text('Test Rencana Kinerja')
  end
end
