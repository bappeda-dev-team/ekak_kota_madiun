require 'rails_helper'

RSpec.describe "IsuDanPermasalahans", type: :feature do
  let(:user) { create(:super_admin) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }

  before(:each) do
    login_as user
    periode
    # setup cookies
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
  end

  scenario 'add data dukung permasalahan', js: true do
    isu_opd = create(:isu_strategis_opd,
                     tahun: '2025',
                     kode_opd: 'test_opd',
                     isu_strategis: 'test isu')
    prm_opd = create(:permasalahan_opd,
                     permasalahan: 'test masalah',
                     tahun: '2025',
                     isu_strategis_opd: isu_opd,
                     kode_opd: 'test_opd')

    visit isu_dan_permasalahans_path

    expect(page).to have_text 'test isu'
    expect(page).to have_text 'test masalah'

    click_on 'Tambah Data Dukung'

    fill_in 'Nama data', with: 'Test Data'
    fill_in 'Keterangan', with: 'test keterangan'

    click_on 'Simpan Data dukung'
    click_on 'Ok'

    expect(page).to have_text 'test masalah'
    expect(page).to have_text 'Test Data'
  end
end
