require 'rails_helper'

RSpec.describe "IndikatorTambahans", type: :system do
  let(:admin) { create(:super_admin) }

  before(:each) do
    login_as admin
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2025')
  end

  context 'indikator lppd outcome opd' do
    it 'create new lppd outcome' do
      visit lppd_outcome_indikators_path

      click_on 'Indikator Outcome LPPD'

      fill_in 'Indikator', with: 'Indikator test'
      fill_in 'Target', with: '10'
      fill_in 'Satuan', with: '%'
      fill_in 'Keterangan', with: 'keterangan a'

      click_on 'Simpan Indikator'

      expect(page).to have_content('Indikator test')
    end

    it 'edit lppd outcome' do
      create(:indikator, indikator: 'test', jenis: 'LPPD', sub_jenis: 'Outcome', kode_opd: 'test_opd', tahun: '2025')

      visit lppd_outcome_indikators_path

      expect(page).to have_content('test')
      # edit new item
      click_on 'Edit'

      fill_in 'Indikator', with: 'Indikator edit'

      click_on 'Simpan Perubahan Indikator'

      expect(page).to have_content('Indikator edit')
    end
  end

  context 'indikator lppd output opd' do
    it 'create new lppd outcome' do
      visit lppd_output_indikators_path

      click_on 'Indikator Output LPPD'

      fill_in 'Indikator', with: 'Indikator test'
      fill_in 'Target', with: '10'
      fill_in 'Satuan', with: '%'
      fill_in 'Keterangan', with: 'keterangan a'

      click_on 'Simpan Indikator'

      expect(page).to have_content('Indikator test')
    end

    it 'edit lppd outcome' do
      create(:indikator, indikator: 'test', jenis: 'LPPD', sub_jenis: 'Output', kode_opd: 'test_opd', tahun: '2025')

      visit lppd_output_indikators_path

      expect(page).to have_content('test')
      # edit new item
      click_on 'Edit'

      fill_in 'Indikator', with: 'Indikator edit'

      click_on 'Simpan Perubahan Indikator'

      expect(page).to have_content('Indikator edit')
    end
  end
end
