require 'rails_helper'

RSpec.feature "Laporans", type: :feature do
  include_context 'sasaran_complete'

  context 'laporan hasil output sasaran' do
    before(:each) { sasaran_complete }

    scenario 'user(eselon_4) create sasaran with output raperda and then showed in laporan', js: true do
      within('#raperda-sasaran') do
        select2('Raperda', from: 'Hasil output', exact_text: true)
        fill_in('Nama output', with: 'raperda test')
        click_on('Simpan Perubahan Sasaran')
      end
      click_on('Ok')

      find('span.sidebar-text', text: 'Laporan').click
      click_on('Output Raperda')
      expect(page).to have_title('Output Raperda')
      expect(page).to have_selector('li.breadcrumb-item', text: 'Output Raperda')
      expect(page).to have_content('Output Raperda Sasaran Kinerja')
      within('.card-header') do
        expect(page).to have_content('Dinas Komunikasi dan Informatika')
      end
      expect(page).to have_content('2025')
      expect(page).to have_content('SasaranTest')
      expect(page).to have_content('Raperda')
      expect(page).to have_content('raperda test')
    end

    scenario 'user(eselon_4) create sasaran with inovasi and then showed in laporan', js: true do
      within('#inovasi-sasaran') do
        select2('Inovasi', from: 'Hasil inovasi', exact_text: true)
        fill_in('Inovasi', with: 'inovasi test')
        select2('Pengembangan', from: 'Jenis inovasi', exact_text: true)
        fill_in('Gambaran nilai kebaruan', with: 'gambaran kebaruan test')
        click_on('Simpan Perubahan Sasaran')
      end
      click_on('Ok')

      find('span.sidebar-text', text: 'Laporan').click
      click_on('Inovasi Sasaran Kinerja')
      expect(page).to have_title('Inovasi Sasaran Kinerja')
      expect(page).to have_selector('li.breadcrumb-item.active', text: 'Inovasi Sasaran Kinerja')
      expect(page).to have_content('Inovasi Sasaran Kinerja')
      within('.card-header') do
        expect(page).to have_content('Dinas Komunikasi dan Informatika')
      end
      expect(page).to have_content('2025')
      expect(page).to have_content('SasaranTest')
      expect(page).to have_content('Inovasi')
      expect(page).to have_content('inovasi test')
      expect(page).to have_css('td.jenis-inovasi', text: 'Pengembangan')
      expect(page).to have_content('GAMBARAN NILAI KEBARUAN')
      expect(page).to have_content('gambaran kebaruan test')
    end

    scenario 'user(eselon_4) create sasaran with penduduk in manual ik', js: true do
      find('span.sidebar-text', text: 'Laporan').click
      click_on('Sasaran Penduduk')
      expect(page).to have_title('Sasaran Penduduk')
      expect(page).to have_selector('li.breadcrumb-item.active', text: 'Sasaran Penduduk')
      within('.card-header') do
        expect(page).to have_content('Laporan Sasaran Penduduk')
        expect(page).to have_content('2025')
      end
      within('#sasaran-penduduk') do
        expect(page).to have_content('SasaranTest')
        expect(page).to have_content('Penduduk')
      end
    end

    scenario 'user(eselon_4) create sasaran with spbe/pemdigi in manual ik', js: true do
      find('span.sidebar-text', text: 'Laporan').click
      click_on('Sasaran SPBE/PEMDIGI')
      expect(page).to have_title('Sasaran SPBE/PEMDIGI')
      expect(page).to have_selector('li.breadcrumb-item.active', text: 'Sasaran SPBE/PEMDIGI')
      within('.card-header') do
        expect(page).to have_content('Laporan Sasaran SPBE/PEMDIGI')
        expect(page).to have_content('2025')
      end
      within('#sasaran-spbe') do
        expect(page).to have_content('SasaranTest')
        expect(page).to have_content('data test informasi test')
      end
    end
  end
end
