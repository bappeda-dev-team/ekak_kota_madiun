require 'rails_helper'

RSpec.describe "Sasarans", type: :feature do
  scenario "new sasaran with pohon kinerja on top", js: true do
    user = create(:eselon_4)
    login_as user

    # setup cookies
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2023')

    visit new_sasaran_path(tipe: user.eselon_user)
    fill_in 'sasaran[sasaran_kinerja]', with: 'Test Rencana Kinerja'
    fill_in 'Indikator kinerja', with: 'Indikator'
    fill_in 'Target', with: '100'
    fill_in 'Satuan', with: '%'
    click_on 'Simpan'
    expect(page).to have_text('Test Rencana Kinerja')
  end

  include_context 'sasaran_complete'

  scenario 'user(eselon_4) create sasaran with inovasi and edit it', js: true do
    sasaran_complete

    within('#inovasi-sasaran') do
      select2('Inovasi', from: 'Hasil inovasi', exact_text: true)
      fill_in('Inovasi', with: 'inovasi test')
      select2('Pengembangan', from: 'Jenis inovasi', exact_text: true)
      fill_in('Gambaran nilai kebaruan', with: 'gambaran kebaruan test')
      click_on('Simpan Perubahan Sasaran')
    end
    click_on('Ok')

    expect(page).to have_css('td.judul-inovasi', text: 'inovasi test')
    expect(page).to have_css('td.jenis-inovasi', text: 'Pengembangan')
    expect(page).to have_css('td.gambaran-inovasi', text: 'gambaran kebaruan test')

    refresh

    click_on('Edit Inovasi')

    within('#edit-inovasi-sasaran') do
      fill_in('Inovasi', with: 'inovasi-ubah-1')
      select2('Baru', from: 'Jenis inovasi', exact_text: true)
      fill_in('Gambaran Nilai Kebaruan', with: 'baru-x')
      click_on('Simpan Perubahan Sasaran')
    end

    click_on('Ok')

    expect(page).to have_css('td.judul-inovasi', text: 'inovasi-ubah-1')
    expect(page).to have_css('td.jenis-inovasi', text: 'Baru')
    expect(page).to have_css('td.gambaran-inovasi', text: 'baru-x')
  end

  scenario 'user(eselon_4) create sasaran and edit rincian', js: true do
    sasaran_complete

    click_on('Tambah Rincian Sasaran')

    within('#form-rincian') do
      fill_in('Jenis layanan', with: 'Layanan Masyarakat')
      fill_in('Penerima manfaat', with: 'Masyarakat Kota Madiun')
      fill_in('Data terpilah', with: 'Kota: 10')
      fill_in('Resiko', with: 'Tidak Ada')
      fill_in('Lokasi pelaksanaan', with: 'Kota Madiun')
      click_on('Simpan')
    end
    click_on('OK')

    expect(page).to have_text('Layanan Masyarakat')
    expect(page).to have_text('Masyarakat Kota Madiun')
    expect(page).to have_text('Kota: 10')
    expect(page).to have_text('Tidak Ada')
    expect(page).to have_text('Kota Madiun')

    # edit it
    click_on('Edit Rincian Sasaran')

    within('#form-rincian') do
      fill_in('Jenis layanan', with: 'lay-jen')
      fill_in('Penerima manfaat', with: 'manfa-pen')
      fill_in('Data terpilah', with: 'pilah-data')
      fill_in('Resiko', with: 'risiko-x')
      fill_in('Lokasi pelaksanaan', with: 'lokpel')
      click_on('Simpan')
    end
    click_on('OK')

    expect(page).to have_text('lay-jen')
    expect(page).to have_text('manfa-pen')
    expect(page).to have_text('pilah-data')
    expect(page).to have_text('risiko-x')
    expect(page).to have_text('lokpel')
  end
end
