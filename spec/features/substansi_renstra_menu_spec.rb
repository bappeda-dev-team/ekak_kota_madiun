require 'rails_helper'

RSpec.feature "Substansi Renstra menu on sidebar", type: :feature do
  context 'display by user' do
    it 'display substansi renstra for super_admin' do
      user = create(:super_admin)
      login_as user

      visit root_path
      expect(page).to have_content('Substansi Renstra')
    end
    it 'display substansi renstra for reviewer' do
      user = create(:reviewer)
      login_as user

      visit root_path
      expect(page).to have_content('Substansi Renstra')
    end

    it 'display substansi renstra for admin opd' do
      user = create(:admin_opd)
      login_as user

      visit root_path
      expect(page).to have_content('Substansi Renstra')
    end
    it 'display substansi renstra for asn' do
      user = create(:asn)
      login_as user

      visit root_path
      expect(page).to have_content('Substansi Renstra')
    end

    it 'should not display substansi renstra for non_aktif' do
      user = create(:non_aktif)
      login_as user

      visit root_path
      expect(page).to_not have_content('Substansi Renstra')
    end
  end

  context 'menu substansi renstra' do
    it 'should have Bab 1 - 7 menu' do
      user = create(:super_admin)
      login_as user

      visit root_path

      find('span.sidebar-text', text: 'Substansi Renstra').click

      expect(page).to have_content('Bab 1')
      expect(page).to have_content('Bab 2')
      expect(page).to have_content('Bab 3')
      expect(page).to have_content('Bab 4')
      expect(page).to have_content('Bab 5')
      expect(page).to have_content('Bab 6')
      expect(page).to have_content('Bab 7')
    end

    let(:user) { create(:super_admin) }

    context 'bab 1' do
      before(:each) do
        login_as user

        visit root_path
        # create_cookie('opd', 'test_opd')
        # create_cookie('tahun', '2025')
        page.driver.browser.set_cookie 'opd=test_opd'
        page.driver.browser.set_cookie 'tahun=2025'
      end

      it 'show Dasar Hukum for selected opd and tahun' do
        find('span.sidebar-text', text: 'Substansi Renstra').click
        find('span.sidebar-text', text: 'Bab 1').click

        user_eselon4 = create(:eselon_4, email: 'usulan@test.com', nik: '123_456')
        sasaran = create(:complete_sasaran, user: user_eselon4, tahun: '2025')
        mandatori = create(:mandatori, peraturan_terkait: 'peraturan y', tahun: '2025', sasaran_id: sasaran.id)
        Usulan.create(usulanable_id: mandatori.id,
                      usulanable_type: 'Mandatori',
                      sasaran_id: sasaran)

        click_on 'Dasar Hukum'
        expect(page).to have_text('Laporan Dasar Hukum')
        expect(page).to have_text('peraturan y')
      end
    end

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
    end

    context 'bab 3' do
      it 'show Permasalahan dan Isu Strategis' do
        login_as user

        visit root_path
        # create_cookie('opd', 'test_opd')
        # create_cookie('tahun', '2025')
        page.driver.browser.set_cookie 'opd=test_opd'
        page.driver.browser.set_cookie 'tahun=2025'

        find('span.sidebar-text', text: 'Substansi Renstra').click
        find('span.sidebar-text', text: 'Bab 3').click

        find('#substansi-renstra-bab-3-permasalahan').click
        expect(page).to have_content('Laporan Permasalahan dan Isu Strategis')
      end

      it 'show Pohon Kinerja' do
        login_as user

        visit root_path
        # create_cookie('opd', 'test_opd')
        # create_cookie('tahun', '2025')
        page.driver.browser.set_cookie 'opd=test_opd'
        page.driver.browser.set_cookie 'tahun=2025'

        find('span.sidebar-text', text: 'Substansi Renstra').click
        find('span.sidebar-text', text: 'Bab 3').click

        find('#substansi-renstra-bab-3-pohon-kinerja').click
        expect(page).to have_content('Laporan Pohon Kinerja')
      end
    end
  end
end
