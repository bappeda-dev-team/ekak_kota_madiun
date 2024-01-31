require 'rails_helper'

RSpec.feature "Laporans", type: :feature do
  context 'laporan hasil output sasaran' do
    scenario 'user(eselon_4) create sasaran with output raperda and then showed in laporan', js: true do
      user = create(:eselon_4)
      login_as user

      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')

      find('span.sidebar-text', text: 'Perencanaan').click
      click_on('Rencana Kinerja')

      click_on('Rencana Kinerja baru')
      fill_in('Rencana kinerja', with: 'SasaranTest')
      fill_in('Indikator kinerja', with: 'IndikatorX')
      fill_in('Target', with: '10')
      fill_in('Satuan', with: '%')
      click_on('Simpan')

      click_on('OK')
      click_on('Buat Manual IK')
      select2('Anggaran', xpath: '/html/body/main/div[1]/div/table/tbody/tr[1]/td[2]/div[1]/span')
      fill_in('manual_ik[tujuan_rhk]', with: 'test')
      fill_in('manual_ik[definisi]', with: 'test')
      fill_in('manual_ik[key_activities]', with: 'test')
      fill_in('manual_ik[formula]', with: 'test')
      select2('Output', xpath: '/html/body/main/div[1]/div/table/tbody/tr[7]/td[2]/div/span')
      checkbox = find_all('#manual_ik_output_data_')
      checkbox.each { |aa| aa.set(true) }
      fill_in('manual_ik[penanggung_jawab]', with: 'test')
      fill_in('manual_ik[penyedia_data]', with: 'test')
      fill_in('manual_ik[sumber_data]', with: 'test')
      fill_in('manual_ik[mulai]', with: 10)
      fill_in('manual_ik[akhir]', with: 20)
      select2('Bulanan', xpath: '/html/body/main/div[1]/div/table/tbody/tr[13]/td[2]/div/span')
      click_on('Simpan Manual ik')
      click_on('OK')
      click_on('Manual')
      fill_in('Urutan', with: 1)
      fill_in('Tahapan kerja', with: 'test_tahapan')
      fill_in('Keterangan', with: 'test_tahapan')
      click_on('Simpan Tahapan')
      click_on('OK')

      within('#raperda-sasaran') do
        select2('Raperda', from: 'Hasil output', exact_text: true)
        fill_in('Nama output', with: 'raperda test')
        click_on('Simpan Perubahan Sasaran')
      end

      find('span.sidebar-text', text: 'Laporan').click
      click_on('Output Raperda')
      expect(page).to have_title('Output Raperda')
      expect(page).to have_selector('li.breadcrumb-item', text: 'Output Raperda')
      expect(page).to have_content('SasaranTest')
      expect(page).to have_content('raperda test')
    end
  end
end
