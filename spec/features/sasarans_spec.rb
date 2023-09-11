require 'rails_helper'

RSpec.feature "Sasarans", type: :feature do
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
    expect(page).to have_content "Rencana Kinerja Baru"

    fill_in 'sasaran[sasaran_kinerja]', with: 'Test Rencana Kinerja'
    fill_in 'indikator', with: 'Indikator'
    fill_in 'target', with: '100'
    fill_in 'satuan', with: '%'
  end
end
