require 'rails_helper'

RSpec.describe "Substansi Renstra Bab 2", type: :feature do
  let(:user) { create(:super_admin) }

  context 'bab 2' do
    it 'show Evaluasi Renstra Item' do
      login_as user

      visit root_path
      # create_cookie('opd', 'test_opd')
      # create_cookie('tahun', '2025')
      page.driver.browser.set_cookie 'opd=test_opd'
      page.driver.browser.set_cookie 'tahun=2025'

      find('span.sidebar-text', text: 'Substansi Renstra').click
      find('span.sidebar-text', text: 'Bab 2').click

      click_on 'Evaluasi Renstra'
      expect(page).to have_content('Laporan Evaluasi Renstra - Periode 2019-2024')
    end

    it 'show Kepegawaian dan Aset Item' do
      login_as user

      visit root_path
      # create_cookie('opd', 'test_opd')
      # create_cookie('tahun', '2025')
      page.driver.browser.set_cookie 'opd=test_opd'
      page.driver.browser.set_cookie 'tahun=2025'

      find('span.sidebar-text', text: 'Substansi Renstra').click
      find('span.sidebar-text', text: 'Bab 2').click

      click_on 'Kepegawaian dan Aset'
      expect(page).to have_title('Bab 2 - Kepegawaian dan Aset')
      expect(page).to have_selector('li.breadcrumb-item', text: 'Substansi Renstra')
      expect(page).to have_selector('li.breadcrumb-item', text: 'Bab 2')
      expect(page).to have_selector('li.breadcrumb-item.active', text: 'Kepegawaian dan Aset')
      expect(page).to have_content('Laporan Kepegawaian dan Aset')
      expect(page).to have_content(user.opd.nama_opd)
      expect(page).to have_content('2025')
    end
  end
end
