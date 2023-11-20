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

  context 'edit tujuan opd form' do
    before(:each) do
      tujuan_opd = create(:tujuan, type: 'TujuanOpd', tahun_awal: '2025', tahun_akhir: '2026', tujuan: 'test tujuan', id_tujuan: 'kode_1')
      indikator_tujuan = create(:indikator, jenis: 'Tujuan', sub_jenis: 'Opd', kode: 'kode_1')
      create(:target, indikator_id: indikator_tujuan.id, target: 10, satuan: '%', tahun: '2025')
      create(:target, indikator_id: indikator_tujuan.id, target: 20, satuan: '%', tahun: '2026')
      visit "/tujuan_opds/#{tujuan_opd.id}/edit"
    end
    it 'should have tujuan in form' do
      expect(page).to have_field('Tujuan', with: 'test tujuan')
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
