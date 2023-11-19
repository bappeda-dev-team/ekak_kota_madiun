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
  context 'new tujuan opd form' do
    before(:each) do
      visit '/tujuan_opds/new'
    end
    it 'should have tahun awal and akhir by periode' do
      expect(page).to have_field('Tahun awal', with: '2025')
      expect(page).to have_field('Tahun akhir', with: '2026')
    end

    it 'should not have target tahun outside periode' do
      expect(page).not_to have_field('tujuan_opd[indikators_attributes][0][targets_attributes][0][tahun]', with: '2020')
    end
    it 'should not have target tahun in periode' do
      expect(page).to have_field('tujuan_opd[indikators_attributes][0][targets_attributes][0][tahun]', with: '2025')
      expect(page).to have_field('tujuan_opd[indikators_attributes][0][targets_attributes][1][tahun]', with: '2026')
    end
  end
end
