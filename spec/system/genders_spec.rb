require 'rails_helper'

RSpec.describe "Gender System", type: :system do
  let(:user) { create(:admin_opd) }
  let(:program_kegiatan) { create(:program_kegiatan) }
  let(:sasaran) { create(:sasaran, user: user, program_kegiatan: program_kegiatan, sasaran_kinerja: 'contoh sasaran_kinerja') }
  let(:rincian) { create :rincian, sasaran: sasaran }

  before(:each) do
    visit root_path
    fill_in "user_login", with: user.email
    fill_in "password", with: user.password
    click_button "Sign in"
  end

  context 'GAP Menu' do
    it 'should genders/gap page' do
      click_link('GAP')
      expect(page).to have_content('GAP Gender')
    end

    it 'show genders/new page' do
      click_link('GAP')
      click_link('Buat Analisis Gender')
      expect(page).to have_current_path(new_gender_path)
    end
  end

  context 'Genders Form' do
    it 'fill new form page' do
      subkegiatans = program_kegiatan
      click_link('GAP')
      click_link('Buat Analisis Gender')
      select2 subkegiatans.nama_subkegiatan, from: 'Subkegiatan'
      fill_in('Akses', with: 'Contoh Data Akses Gender')
      fill_in('Partisipasi', with: 'Contoh Data Partisipasi Gender')
      fill_in('Kontrol', with: 'Contoh Data Kontrol Gender')
      fill_in('Manfaat', with: 'Contoh Data Manfaat Gender')
      fill_in('Penyebab internal', with: 'Contoh Data Penyebab Internal Gender')
      fill_in('Penyebab external', with: 'Contoh Data Penyebab External Gender')
      fill_in('Reformulasi tujuan', with: 'Contoh Data Reformulasi Tujuan Gender')
      fill_in('Sasaran subkegiatan', with: 'Contoh Data Sasaran Subkegiatan Gender')
      fill_in('Penerima manfaat', with: 'Contoh Data Penerima Manfaat Gender')
      fill_in('Data terpilah', with: 'Contoh Data Terpilah Gender')
      fill_in('Indikator', with: 'Contoh Data Indikator Gender')
      fill_in('Target', with: 'Contoh Data Target Indikator Gender')
      fill_in('Satuan', with: 'Contoh Data Satuan Gender')
      click_button('Simpan Gender Analysis Pathway')
      expect(page).to have_content('Contoh Data Akses Gender')
    end
  end
end
