require 'rails_helper'

RSpec.feature "PerencanaanKota", type: :feature do
  let(:admin_kota) { create(:super_admin) }
  context 'Sasaran Kota' do
    before do
      tematik = create(:tematik, tahun: 2025)
      indikator_tematik = create(:indikator, tahun: 2025,
                                             jenis: 'Tematik',
                                             sub_jenis: 'Tematik',
                                             kode: tematik.id)
      sub_tematik = create(:tematik,
                           tema: 'strategi kota a',
                           tahun: 2025, type: 'SubTematik',
                           tematik_ref_id: tematik)
      indikator_subtematik = create(:indikator,
                                    indikator: 'indikator kota a',
                                    target: 100,
                                    satuan: '%',
                                    tahun: 2025,
                                    jenis: 'Tematik',
                                    sub_jenis: 'SubTematik',
                                    kode: sub_tematik.id)
      pohon_sub = create(:pohon, pohonable_type: 'SubTematik',
                                 pohonable_id: sub_tematik.id,
                                 tahun: 2025)
      tujuan_kota = create(:tujuan_kota)
    end
    scenario 'admin kota view sasaran kota menu that have same value as subtematik and sub sub tematik', js: true do
      login_as admin_kota

      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')

      find('span.sidebar-text', text: 'Perencanaan Kota').click
      click_on('Sasaran Kota')

      expect(page).to have_content('strategi kota a')
      expect(page).to have_content('indikator kota a')
    end

    scenario 'edit new sasaran kota', js: true do
      login_as admin_kota

      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')

      find('span.sidebar-text', text: 'Perencanaan Kota').click
      click_on('Sasaran Kota')

      click_on('Edit')
      select2('Tujuan Kota', from: 'Tujuan kota')
      fill_in('Sasaran', with: 'Contoh Sasaran Kota')
      click_on('Simpan Sasaran Kota')
      click_on('Ok')

      expect(page).to have_content('strategi kota a')
      expect(page).to have_content('Contoh Sasaran Kota')
      expect(page).to have_content('indikator kota a')
    end

    scenario 'edit existing sasaran kota', js: true do
      login_as admin_kota

      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')

      find('span.sidebar-text', text: 'Perencanaan Kota').click
      click_on('Sasaran Kota')

      click_on('Edit')
      select2('Tujuan Kota', from: 'Tujuan kota')
      fill_in('Sasaran', with: 'Contoh Sasaran Kota')
      click_on('Simpan Sasaran Kota')
      click_on('Ok')

      visit sasaran_kota_path

      click_on('Edit')
      fill_in('Sasaran', with: 'Edit Sasaran Kota')
      click_on('Simpan Sasaran Kota')
      click_on('Ok')

      expect(page).to have_content('strategi kota a')
      expect(page).to have_content('Edit Sasaran Kota')
      expect(page).to have_content('indikator kota a')
    end
  end
end
