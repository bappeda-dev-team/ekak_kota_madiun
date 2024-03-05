require 'rails_helper'

RSpec.describe 'Rekap Pagu Seluruh OPD', type: :feature do
  let(:super_admin) { create(:super_admin) }
  let(:admin_opd) { create(:admin_opd) }

  it 'have rekap pagu menu for super admin user' do
    login_as super_admin

    visit root_path
    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
    # page.driver.browser.set_cookie 'opd=test_opd'
    # page.driver.browser.set_cookie 'tahun=2025'

    find('span.sidebar-text', text: 'Laporan').click
    find('span.sidebar-text', text: 'Rekap Pagu').click

    expect(page).to have_content('Pagu Ranwal')
    expect(page).to have_content('Pagu Rancangan')
    expect(page).to have_content('Pagu Rankir')
    expect(page).to have_content('Perbandingan Pagu')
  end

  it 'should not have rekap pagu menu for admin opd' do
    login_as admin_opd

    visit root_path
    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
    # page.driver.browser.set_cookie 'opd=test_opd'
    # page.driver.browser.set_cookie 'tahun=2025'

    find('span.sidebar-text', text: 'Laporan').click

    expect(page).to_not have_content('Rekap Pagu')
  end
end
