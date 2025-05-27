require 'rails_helper'

RSpec.shared_context 'sasaran_complete' do
  def login_eselon4
    user = create(:eselon_4)
    login_as user

    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
  end

  def new_sasaran
    find('span.sidebar-text', text: 'Perencanaan').click
    click_on('Rencana Kinerja')

    click_on('Rencana Kinerja baru')
    fill_in('Rencana kinerja', with: 'SasaranTest')
    fill_in('Indikator kinerja', with: 'IndikatorX')
    fill_in('Target', with: '10')
    fill_in('Satuan', with: '%')
    click_on('Simpan')
    click_on('OK')
  end

  def manual_ik_sasaran
    click_on('Buat Manual IK')
    # Perspektif
    select2('Penerima Layanan', xpath: '/html/body/main/div/div/div/table/tbody/tr[1]/td[2]/div[1]/span')
    # Tujuan RHK
    fill_in('manual_ik[tujuan_rhk]', with: 'Tujuannya testing')
    fill_in('manual_ik[definisi]', with: 'Test manual ik')
    fill_in('manual_ik[key_activities]', with: 'Test aktifitas')
    fill_in('manual_ik[formula]', with: '(jumlah test / pass test) * 100')
    # Jenis indikator kinerja
    select2('Output', xpath: '/html/body/main/div/div/div/table/tbody/tr[7]/td[2]/div/span')
    expect(page).not_to have_field('manual_ik[data_dan_informasi]')

    # before spbe don't show data dan informasi
    checkbox = find_all('.manual-ik-output-data')
    checkbox.each { |aa| aa.set(true) }

    click_button 'Tambah Input'
    find_all('textarea[name="manual_ik[data_dan_informasi][]"]')[0].set('data test informasi test')
    find_all('textarea[name="manual_ik[data_dan_informasi][]"]')[1].set('data 2')

    fill_in('manual_ik[penanggung_jawab]', with: 'test')
    fill_in('manual_ik[penyedia_data]', with: 'test')
    fill_in('manual_ik[sumber_data]', with: 'test')
    fill_in('manual_ik[mulai]', with: 10)
    fill_in('manual_ik[akhir]', with: 20)
    select2('Bulanan', xpath: '/html/body/main/div/div/div/table/tbody/tr[14]/td[2]/div/span')
    click_on('Simpan Manual ik')
    click_on('OK')
  end

  def tahapan
    click_on('Renaksi Manual')
    fill_in('Urutan', with: 1)
    fill_in('Tahapan kerja', with: 'test_tahapan')
    fill_in('Keterangan', with: 'test_tahapan')
    click_on('Simpan Tahapan')
    click_on('Ok')
    sleep 2
  end

  def sasaran_complete
    login_eselon4
    new_sasaran
    manual_ik_sasaran
    tahapan
  end
end
