require 'rails_helper'

RSpec.describe "Usulan Inovasi", type: :feature do
  let(:kota_madiun) { create(:lembaga) }
  let(:bappeda) { create(:bappeda, lembaga: kota_madiun) }
  let(:admin_kota) { create(:admin_kota, opd: bappeda) }
  let(:tahun_dua_lima) { create(:dua_lima) }
  let(:eselon4) do
    create(:eselon_4, nik: '19988822211132187',
                      nama: 'Wadi Ah',
                      email: '19988822211132187@test.com',
                      opd: bappeda)
  end
  let(:strategi) do
    create(:strategi, tahun: '2025', role: 'eselon_4',
                      nip_asn: eselon4.nip_asn,
                      opd: bappeda)
  end

  let(:sasaran_strategis) do
    create(:sasaran, user: eselon4, tahun: '2025', strategi: strategi)
  end

  before(:each) do
    create(:base_periode)
    tahun_dua_lima
    login_as admin_kota

    visit root_path
  end

  scenario 'admin kota open inovasi page and create new inovasi for bappeda', js: true do
    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 'Badan Perencanaan', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    # click the notification
    click_on 'Ok'

    # find menu
    find('span.sidebar-text', text: 'Data Master').click
    find('span.sidebar-text', text: 'Master Usulan').click
    find('span.sidebar-text', text: 'Inisiatif Walikota').click

    expect(page).to have_text('Usulan Inisiatif Walikota')
    expect(page).to have_text('Tambah Usulan')

    find('.btn', text: 'Tambah Usulan').click
    within('#form-modal-body') do
      select2 'Badan Perencanaan', from: 'Opd'
      fill_in 'Usulan', with: 'InovasiWalikotaB'
      fill_in 'Manfaat', with: 'Manfaat A'
      fill_in 'Uraian', with: 'Uraian Z'
      click_button 'Simpan Inisiatif Walikota baru'
    end

    # click the notification
    click_on 'Ok'

    expect(page).to have_text('InovasiWalikotaB')
    # change user
    logout

    login_as eselon4
    within(".filter-form") do
      select2 '2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]'
      select2 'Badan Perencanaan', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]'
      click_on 'Aktifkan'
    end
    sasaran_strategis
    visit root_path
    # find menu
    find('span.sidebar-text', text: 'Perencanaan').click
    find('span.sidebar-text', text: 'Usulan').click
    find('span.sidebar-text', text: 'Inisiatif Walikota').click

    expect(page).to have_text('InovasiWalikotaB')
    # expect(page).to have_button('Ambil Usulan')

    # click_button 'Ambil Usulan'
    # click the notification
    # click_on 'Ok'
    # expect(page).to have_button('Siap Digunakan')

    find('span.sidebar-text', text: 'Rencana Kinerja').click
    expect(page).to have_text('Rencana Kinerja Tahun 2025')
    click_link 'Input Rincian'
    expect(page).to have_text('Usulan')
  end
end
