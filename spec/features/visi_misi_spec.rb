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
    select2 '2025-2029 (RPJMD)', xpath: '/html/body/div[2]/div/div/div[2]/form/div[3]/span'
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

  # misi
  scenario 'input misi kota', js: true do
    login_as admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi', lembaga: admin_kota.opd.lembaga)

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
    find('span.sidebar-text', text: 'Misi Kota').click

    expect(page).to have_text('Misi Kepala Daerah')

    within "#visi_#{visi.id}" do
      click_on('Tambah Misi Kepala Daerah')
    end
    within '#form-modal-body' do
      fill_in 'Misi', with: 'Contoh Misi'
      fill_in 'Keterangan', with: 'no keterangan'
      click_button 'Simpan Misi'
    end

    click_on 'Ok'

    expect(page).to have_text 'ContohVisi'
    expect(page).to have_text '1.1'
    expect(page).to have_text 'Contoh Misi'
  end
  scenario 'edit misi kota', js: true do
    login_as admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi', lembaga: admin_kota.opd.lembaga)
    misi = create(:misi, visi: visi, lembaga: admin_kota.opd.lembaga)

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
    find('span.sidebar-text', text: 'Misi Kota').click

    expect(page).to have_text('Misi Kepala Daerah')

    within "#misi_#{misi.id}" do
      click_on('Edit')
    end
    within '#form-modal-body' do
      fill_in 'Misi', with: 'Contoh Misi 123'
      fill_in 'Keterangan', with: 'keterangan a'
      click_button 'Simpan Perubahan Misi'
    end

    click_on 'Ok'

    expect(page).to have_text 'ContohVisi'
    expect(page).to have_text '1.1'
    expect(page).to have_text 'Contoh Misi 123'
    expect(page).to have_text 'keterangan a'
  end
  scenario 'hapus misi kota', js: true do
    login_as admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi', lembaga: admin_kota.opd.lembaga)
    misi = create(:misi, misi: 'Contoh Misi 123',
                         keterangan: 'keterangan a',
                         visi: visi, lembaga: admin_kota.opd.lembaga)

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
    find('span.sidebar-text', text: 'Misi Kota').click

    expect(page).to have_text('Misi Kepala Daerah')

    within "#misi_#{misi.id}" do
      click_on('Hapus')
    end
    click_on 'Ya'
    click_on 'OK'

    expect(page).to have_text 'ContohVisi'
    expect(page).to_not have_text '1.1'
    expect(page).to_not have_text 'Contoh Misi 123'
    expect(page).to_not have_text 'keterangan a'
  end
end
