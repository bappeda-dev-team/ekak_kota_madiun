require 'rails_helper'

RSpec.feature "TujuanOpds", type: :feature do
  let(:user) { create(:eselon_4) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }

  before(:each) do
    login_as user
    periode
    # setup cookies
    visit root_path

    page.driver.browser.set_cookie 'tahun=2025'
  end
  context 'new tujuan opd' do
    it 'form should have tahun awal and akhir by periode' do
      visit '/tujuan_opds/new'
      expect(page).to have_select('Tahun awal', options: ['', '2025'])
      expect(page).to have_select('Tahun akhir', options: ['', '2026'])
    end
  end
end
