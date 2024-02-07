require 'rails_helper'

RSpec.describe "TujuanOpds", type: :feature do
  let(:user) { create(:eselon_4) }
  let(:periode) { create(:periode, tahun_awal: '2025', tahun_akhir: '2026') }
  let(:urusan) { create(:master_urusan) }
  let(:bidang_urusan) { create(:master_bidang_urusan) }
  let(:urusan_rutin) { create(:master_urusan, nama_urusan: 'Rutin', kode_urusan: 'X', id_unik_sipd: 'X') }
  let(:bidang_urusan_rutin) { create(:master_bidang_urusan, nama_bidang_urusan: 'Rutin', kode_bidang_urusan: 'X.XX', id_unik_sipd: 'X.XX') }

  context 'new tujuan opd form' do
    before(:each) do
      login_as user
      periode
      # setup cookies
      visit root_path

      page.driver.browser.set_cookie 'opd=test_opd'
      page.driver.browser.set_cookie 'tahun=2025'
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
      login_as user
      periode
      # setup cookies
      visit root_path

      page.driver.browser.set_cookie 'opd=test_opd'
      page.driver.browser.set_cookie 'tahun=2025'
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

  context 'user admin creating new tujuan opd' do
    before(:each) do
      opd = create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')
      admin = create(:admin_opd, opd: opd)
      periode

      login_as admin

      visit root_path

      # setup cookies

      create_cookie('opd', '2.16.2.20.2.21.04.000')
      create_cookie('tahun', '2025')
    end
    scenario 'input new tujuan opd', js: true do
      urusan
      urusan_rutin
      bidang_urusan
      bidang_urusan_rutin
      find('span.sidebar-text', text: 'Perencanaan OPD').click
      click_on 'Tujuan OPD'

      click_on('Buat Tujuan OPD Baru')

      within('#form-modal-body') do
        select2(urusan_rutin.nama_urusan, from: 'Urusan')
        select2(bidang_urusan_rutin.nama_bidang_urusan, from: 'Bidang urusan')
        fill_in('Tujuan', with: 'tujuan_1')
        fill_in('Indikator', with: 'indikator_x')
        fill_in('Rumus perhitungan', with: 'rumus a')
        fill_in('Sumber data', with: 'sumber data xxx')
        fill_in('tujuan_opd[indikators_attributes][0][targets_attributes][0][target]', with: '10')
        fill_in('tujuan_opd[indikators_attributes][0][targets_attributes][0][satuan]', with: '%')
        fill_in('tujuan_opd[indikators_attributes][0][targets_attributes][1][target]', with: '20')
        fill_in('tujuan_opd[indikators_attributes][0][targets_attributes][1][satuan]', with: '%')
        click_on 'Simpan Tujuan opd'
      end
      click_on 'Ok'

      expect(page).to have_content('tujuan_1')
      expect(page).to have_content('indikator_x')
      expect(page).to have_content('rumus a')
      expect(page).to have_content('sumber data xxx')
      expect(page).to have_content('10')
      expect(page).to have_content('%')
      expect(page).to have_content('20')
      expect(page).to have_content('%')
    end
  end
end
