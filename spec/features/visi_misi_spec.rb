require 'rails_helper'

RSpec.describe "Visi dan Misi", type: :feature do
  let(:admin_kota) { create(:super_admin) }
  let(:tahun_dua_lima) { create(:dua_lima) }
  let(:periode) { create(:base_periode) }

  scenario 'input visi kota', js: true do
    login_as admin_kota
    periode
    tahun_dua_lima

    visit root_path

    # create_cookie('opd', '2.16.2.20.2.21.04.000')
    # create_cookie('tahun', '2025')
    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 'Dinas', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'
    expect(page).to have_text('Kota Madiun')

    find('span.sidebar-text', text: 'Perencanaan Kota').click
    find('span.sidebar-text', text: 'Visi Kota').click

    expect(page).to have_text('Visi Kepala Daerah')

    click_on('Tambah Visi Kepala Daerah')
    fill_in 'Visi', with: 'Contoh Visi'
    fill_in 'Keterangan', with: 'no keterangan'
    click_button 'Simpan Visi'

    click_on 'Ok'

    expect(page).to have_text 'Contoh Visi'
  end
  scenario 'edit visi kota', js: true do
    login_as admin_kota
    periode
    tahun_dua_lima
    create(:visi, lembaga: admin_kota.opd.lembaga)

    visit root_path

    # create_cookie('opd', '2.16.2.20.2.21.04.000')
    # create_cookie('tahun', '2025')
    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 'Dinas', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'
    expect(page).to have_text('Kota Madiun')

    find('span.sidebar-text', text: 'Perencanaan Kota').click
    find('span.sidebar-text', text: 'Visi Kota').click

    expect(page).to have_text('Visi Kepala Daerah')

    find('a.btn', text: 'Edit').click

    fill_in 'Visi', with: 'visi-new'
    fill_in 'Keterangan', with: 'keterangan-new'
    click_button 'Simpan Perubahan Visi'

    click_on 'Ok'
    expect(page).to have_text('visi-new')
    expect(page).to have_text('keterangan-new')
  end
  scenario 'hapus visi kota', js: true do
    login_as admin_kota
    periode
    tahun_dua_lima
    create(:visi, lembaga: admin_kota.opd.lembaga)

    visit root_path

    # create_cookie('opd', '2.16.2.20.2.21.04.000')
    # create_cookie('tahun', '2025')
    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 'Dinas', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'
    expect(page).to have_text('Kota Madiun')

    find('span.sidebar-text', text: 'Perencanaan Kota').click
    find('span.sidebar-text', text: 'Visi Kota').click

    expect(page).to have_text('Visi Kepala Daerah')

    find('a.btn', text: 'Hapus').click
    click_on 'Ya'
    click_on 'OK'
    expect(page).not_to have_text('VISI CONTOH')
  end
end
