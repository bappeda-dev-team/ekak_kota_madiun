require 'rails_helper'

RSpec.describe "IsuDanPermasalahansOpd", type: :feature do
  let(:user) { create(:super_admin, opd: create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }
  let(:urusan) { create(:master_urusan) }
  let(:bidang_urusan) { create(:master_bidang_urusan) }

  before(:each) do
    login_as user
    periode
    urusan
    bidang_urusan
    # setup cookies
    visit root_path

    create_cookie('opd', '2.16.2.20.2.21.04.000')
    create_cookie('tahun', '2025')
  end

  scenario 'create new isu strategis opd', js: true do
    visit isu_dan_permasalahans_path

    click_on 'Tambah Isu Strategis'
    fill_in 'Isu strategis', with: 'Isu Strategis A'
    fill_in 'Permasalahan', with: 'Permasalahan A'

    fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][0][nama_data]', with: 'test data 1'
    fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][0][jumlah]', with: 10
    fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][0][satuan]', with: '%'

    # fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][1][nama_data]', with: 'test data 2'
    # fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][1][jumlah]', with: 20
    # fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][1][satuan]', with: '%'

    click_on 'Simpan Isu strategis opd'
    click_on 'Ok'

    expect(page).to have_content(bidang_urusan.nama_bidang_urusan)
    expect(page).to have_content('Isu Strategis A')
    expect(page).to have_content('Permasalahan A')
    # data 1
    expect(page).to have_content('test data 1')
    expect(page).to have_content('10 %')
    expect(page).to have_content('2025')
    # data 2
    # expect(page).to have_content('test data 2')
    # expect(page).to have_content('20 %')
    # expect(page).to have_content('2026')
  end

  scenario 'add data dukung permasalahan', js: true do
    isu_opd = create(:isu_strategis_opd,
                     tahun: '2025',
                     kode_opd: '2.16.2.20.2.21.04.000',
                     isu_strategis: 'test isu')
    create(:permasalahan_opd,
           permasalahan: 'test masalah',
           tahun: '2025',
           isu_strategis_opd: isu_opd,
           kode_opd: '2.16.2.20.2.21.04.000')
    create(:permasalahan_opd,
           permasalahan: 'test masalah 2',
           tahun: '2025',
           isu_strategis_opd: isu_opd,
           kode_opd: '2.16.2.20.2.21.04.000')

    visit isu_dan_permasalahans_path

    click_on 'Edit'

    fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][0][nama_data]', with: 'Test Data'
    fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][0][jumlah]', with: 10
    fill_in 'isu_strategis_opd[permasalahan_opds_attributes][0][data_dukungs_attributes][0][satuan]', with: '%'

    click_on 'Simpan Perubahan Isu strategis opd'
    click_on 'Ok'

    expect(page).to have_text 'Test Data'
    expect(page).to have_text '10 %'
  end
end
