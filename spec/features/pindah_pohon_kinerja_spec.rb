require 'rails_helper'

RSpec.feature "PindahPohonKinerjas", type: :feature do
  let(:user) { create(:super_admin) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }

  def strategi(role: '', strategi: 'test-1', opd_id: user.opd.id, strategi_ref_id: '')
    create(:strategi,
           type: 'StrategiPohon',
           strategi: strategi,
           opd_id: opd_id,
           tahun: '2025',
           nip_asn: '',
           strategi_ref_id: strategi_ref_id,
           role: role)
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
end
