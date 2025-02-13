require 'rails_helper'

RSpec.describe "Usulan Inovasi", type: :feature do
  let(:bappeda) { create(:bappeda) }
  let(:admin_kota) { create(:admin_kota, opd: bappeda) }
  let(:tahun_dua_lima) { create(:dua_lima) }

  before(:each) do
    create(:base_periode)
    tahun_dua_lima
    login_as admin_kota

    visit root_path
  end

  scenario 'admin kota open inovasi page and create new inovasi for bappeda', js: true do
    within(".filter-form") do
      select2('2025', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[3]')
      select2('Badan Perencanaan', xpath: '//*[@id="navbarSupportedContent"]/ul/li[1]/form/div/span[1]')
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
    fill_in 'Usulan', with: 'InovasiWalikotaB'
    fill_in 'Manfaat', with: 'Manfaat A'
    fill_in 'Uraian', with: 'Uraian Z'
    click_button 'Simpan Inisiatif Walikota baru'

    # click the notification
    click_on 'Ok'

    expect(page).to have_text('InovasiWalikotaB')
    # create_cookie('opd', 'test_opd')
    # create_cookie('tahun', '2025')
    # page.driver.browser.set_cookie 'opd=test_opd'
    # page.driver.browser.set_cookie 'tahun=2025'
  end
end
