require 'rails_helper'

RSpec.describe "Tujuan Kota", type: :feature do
  let(:admin_kota) { create(:super_admin) }
  let(:tahun_dua_lima) { create(:dua_lima) }
  let(:periode) { create(:base_periode) }

  scenario 'input tujuan kota baru oleh admin kota', js: true do
    # Capybara.default_max_wait_time = 10
    admin_kota
    periode
    tahun_dua_lima
    visi = create(:visi, visi: 'ContohVisi', lembaga: admin_kota.opd.lembaga)
    misi = create(:misi, visi: visi, lembaga: admin_kota.opd.lembaga)

    visit root_path

    fill_in 'user_login', with: admin_kota.nik
    fill_in 'password', with: admin_kota.password
    click_on 'Sign in'

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
    visit root_path

    find('span.sidebar-text', text: 'Perencanaan Kota').click
    find('span.sidebar-text', text: 'Tujuan Kota').click
    expect(page).to have_css('.loader')

    page.has_css?('#tujuan-kota-card')

    expect(page).to have_text('Tujuan Kota Periode 2025 - 2026')
  end
end
