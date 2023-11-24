require 'rails_helper'

RSpec.feature "PindahPohonKinerjas", type: :feature do
  let(:user) { create(:super_admin) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }

  def strategi(strategi_ref_id: '', **args)
    create(:strategi,
           type: 'StrategiPohon',
           strategi: 'test-1',
           opd_id: user.opd.id,
           tahun: '2025',
           nip_asn: '',
           strategi_ref_id: strategi_ref_id,
           role: '',
           **args)
  end

  def indikator(jenis: '', kode: '', indikator: 'indikator-test')
    create(:indikator, indikator: indikator,
                       target: '10', satuan: '%', tahun: '2025',
                       jenis: jenis, kode: kode)
  end

  context 'pindah pohon opd dan bawahannya' do
    before(:each) do
      login_as user
      periode
      # setup cookies
      visit root_path

      # create_cookie('opd', 'test_opd')
      # create_cookie('tahun', '2023')
      page.driver.browser.set_cookie 'opd=test_opd'
      page.driver.browser.set_cookie 'tahun=2025'
    end
    it 'pohon diupdate maka bawahan mengikuti' do
      opd_id = user.opd.id
      strategic = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-1')

      strategic_2 = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-2')

      tactical = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: strategic.id, strategi: 'tactical-1')

      tactical_2 = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: '', strategi: 'tactical-2')

      operational = strategi(opd_id: opd_id, role: 'eselon_4', strategi_ref_id: tactical_2.id, strategi: 'operational-2')

      visit cascading_pohon_kinerja_opds_path
      # visit '/pohon_Kinerja_opds/cascading'

      expect(page).to have_text('strategic-1')
      expect(page).to have_text('strategic-2')
      expect(page).to have_text('tactical-1')
      expect(page).not_to have_text('tactical-2')
      expect(page).not_to have_text('operational-2')

      tactical.update!(strategi_ref_id: strategic_2.id)
      tactical_2.update!(strategi_ref_id: strategic.id)

      visit cascading_pohon_kinerja_opds_path

      expect(page).to have_text('strategic-1')
      expect(page).to have_text('strategic-2')
      expect(page).to have_text('tactical-1')
      expect(page).to have_text('tactical-2')
      expect(page).to have_text('operational-2')
    end
  end

  context 'with view', js: true do
    before(:each) do
      login_as user
      periode
      # setup cookies
      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')
    end

    it 'pindah di pohon opd', headless: true do
      opd_id = user.opd.id
      strategic = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-1')

      strategic_2 = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-2')

      tactical = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: strategic.id, strategi: 'tactical-1')

      tactical_2 = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: '', strategi: 'tactical-2')

      operational = strategi(opd_id: opd_id, role: 'eselon_4', strategi_ref_id: tactical_2.id, strategi: 'operational-2')

      visit cascading_pohon_kinerja_opds_path
      # visit '/pohon_Kinerja_opds/cascading'

      expect(page).to have_text('strategic-1')
      expect(page).to have_text('strategic-2')
      expect(page).not_to have_text('tactical-2')
      expect(page).not_to have_text('operational-2')

      within("#strategi_pohon_#{strategic.id}") do
        click_on "Tampilkan"
      end

      expect(page).to have_text('tactical-1')

      within("#strategi_pohon_#{tactical.id}") do
        click_on "Pindah"
      end

      expect(page).to have_text('Form')

      select2 'strategic-2', from: 'Target pohon'
      click_on "Simpan Perubahan"

      click_on "OK"

      within("#strategi_pohon_#{strategic_2.id}") do
        click_on "Tampilkan"
      end

      expect(page).to have_text('tactical-1')
    end

    it 'pindah ke pohon kota', headless: true do
      opd_id = user.opd.id

      # strategic - tactical to strategic_kota - tactical
      strategic = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-1')

      strategic_kota = strategi(opd_id: opd_id, role: 'strategi_pohon_kota', strategi: 'strategic-kota-1', type: '')
      pohon_kota = create(:pohon,
                          pohonable_type: 'Strategi',
                          pohonable_id: strategic_kota.id,
                          role: 'strategi_pohon_kota',
                          opd_id: opd_id,
                          tahun: '2025')

      tactical = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: strategic.id, strategi: 'tactical-1')

      visit cascading_pohon_kinerja_opds_path

      expect(page).to have_text('strategic-1')
      expect(page).to have_text('strategic-kota-1')

      within("#strategi_pohon_#{strategic.id}") do
        click_on "Tampilkan"
      end

      expect(page).to have_text('tactical-1')

      within("#strategi_pohon_#{tactical.id}") do
        click_on "Pindah"
      end

      select2 'strategic-kota-1', from: 'Target pohon', match: :first
      click_on "Simpan Perubahan"

      # sweetalert popup
      click_on "OK"

      click_on "Show All"
      expect(page).to have_text('tactical-1')
    end

    it 'pindah level dari operational ke tactical', headless: true do
      opd_id = user.opd.id

      # strategic - tactical to strategic_kota - tactical
      strategic = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-1')

      tactical = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: strategic.id, strategi: 'tactical-1')

      operational = strategi(opd_id: opd_id,
                             role: 'eselon_4',
                             strategi_ref_id: tactical.id,
                             strategi: 'operational-1')

      visit cascading_pohon_kinerja_opds_path

      expect(page).to have_text('strategic-1')

      within("#strategi_pohon_#{strategic.id}") do
        click_on "Tampilkan"
      end

      expect(page).to have_text('tactical-1')

      within("#strategi_pohon_#{tactical.id}") do
        click_on "Tampilkan"
      end

      expect(page).to have_text('operational-1')

      within("#strategi_pohon_#{operational.id}") do
        click_on "Pindah"
      end

      select2 'Tactical', from: 'Level pohon', match: :first
      select2_select 'strategic-1', from: 'Target pohon', search: true, match: :first

      click_on "Simpan Perubahan"

      # sweetalert popup
      click_on "OK"

      within("#strategi_pohon_#{strategic.id}") do
        click_on "Tampilkan"
      end
      expect(page).to have_text('operational-1')
    end
    it 'pindah level dari tactical ke strategic' do
      opd_id = user.opd.id

      # strategic - tactical to strategic_kota - tactical
      strategic = strategi(opd_id: opd_id, role: 'eselon_2', strategi: 'strategic-1')

      tactical = strategi(opd_id: opd_id, role: 'eselon_3', strategi_ref_id: strategic.id, strategi: 'tactical-1')

      visit cascading_pohon_kinerja_opds_path

      expect(page).to have_text('strategic-1')
      expect(page).not_to have_text('tactical-1')

      within("#strategi_pohon_#{strategic.id}") do
        click_on "Tampilkan"
      end

      expect(page).to have_text('tactical-1')

      within("#strategi_pohon_#{tactical.id}") do
        click_on "Pindah"
      end

      select2 'Strategic', from: 'Level pohon', match: :first
      # select2_select 'strategic-1', from: 'Target pohon', search: true, match: :first

      click_on "Simpan Perubahan"

      # sweetalert popup
      click_on "OK"

      expect(page).to have_text('tactical-1')
    end
  end
end
