require 'rails_helper'

RSpec.describe ManualIk do
  scenario "sasaran kinerja manual ik output data - spbe/pemdigi", js: true do
    user = create(:eselon_4)
    login_as user

    # setup cookies
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')

    buat_sasaran_baru
    expect(page).to have_text('Test Rencana Kinerja')
    buat_manual_ik_sasaran_output_pemdigi
    sasaran_pemdigi = user.sasarans.first
    expect(sasaran_pemdigi.sasaran_spbe?).to be(true)
  end

  private

  def buat_sasaran_baru
    find('span.sidebar-text', text: 'Perencanaan').click
    click_on('Rencana Kinerja')

    click_on('Rencana Kinerja baru')
    fill_in 'sasaran[sasaran_kinerja]', with: 'Test Rencana Kinerja'
    fill_in 'Indikator kinerja', with: 'Indikator'
    fill_in 'Target', with: '100'
    fill_in 'Satuan', with: '%'
    click_on 'Simpan'
    click_on('OK')
  end

  def buat_manual_ik_sasaran_output_pemdigi
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
    checkbox = find_all('.manual-ik-output-data')
    checkbox.each { |aa| aa.set(true) if aa.value == 'spbe/pemdigi' }
    fill_in('manual_ik[penanggung_jawab]', with: 'test')
    fill_in('manual_ik[penyedia_data]', with: 'test')
    fill_in('manual_ik[sumber_data]', with: 'test')
    fill_in('manual_ik[mulai]', with: 10)
    fill_in('manual_ik[akhir]', with: 20)
    select2('Bulanan', xpath: '/html/body/main/div/div/div/table/tbody/tr[13]/td[2]/div/span')
    click_on('Simpan Manual ik')
    click_on('OK')
  end
end
