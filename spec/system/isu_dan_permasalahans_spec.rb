require 'rails_helper'

RSpec.describe "IsuDanPermasalahans", type: :system do
  let(:user) { create(:eselon_4) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }

  before(:each) do
    login_as user
    periode
    # setup cookies
    page.driver.browser.set_cookie 'opd=test_opd'
    page.driver.browser.set_cookie 'tahun=2025'
  end

  context 'index' do
    it 'should show permasalahan dan isu strategis opd' do
      opd = user.opd
      isu_opd = create(:isu_strategis_opd,
                       tahun: '2025',
                       kode_opd: opd.kode_unik_opd,
                       isu_strategis: 'test isu')

      page.driver.post('/isu_dan_permasalahans/filter',
                       tahun: '2025', kode_opd: 'test_opd')

      expect(page).to have_text(opd.nama_opd)
      expect(page).to have_text('2025')

      expect(page).to have_text(isu_opd.isu_strategis)
    end
  end
end
