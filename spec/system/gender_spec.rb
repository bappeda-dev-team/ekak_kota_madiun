require 'rails_helper'

RSpec.describe "Gender Form", type: :system do
  let(:user) { create(:eselon_4) }
  let(:subkegiatan) { create(:program_kegiatan, nama_subkegiatan: 'Test Sub', opd: user.opd) }
  let(:strategi) { create(:strategi, tahun: '2022', nip_asn: user.nik, sasaran_id: '') }
  let(:sasaran) do
    create(:sasaran, user: user, program_kegiatan: subkegiatan,
                     sasaran_kinerja: 'contoh sasaran_kinerja',
                     penerima_manfaat: 'contoh penerima_manfaat',
                     tahun: '2022', id_rencana: '123',
                     strategi_id: strategi.id)
  end
  let(:indikator_sasaran) do
    create(:indikator_sasaran, indikator_kinerja: 'test ind',
                               target: '100', satuan: '%',
                               sasaran_id: sasaran.id_rencana)
  end
  let(:rincian) { create :rincian, sasaran: sasaran }
  let(:tahapan) { create(:tahapan, sasaran: sasaran, id_rencana_aksi: 'test-a', id_rencana: '123') }
  let(:aksi) { create(:aksi, id_rencana_aksi: 'test-a', target: 20, bulan: 3) }

  def sasarans_gender
    sasaran
    indikator_sasaran
    rincian
    tahapan
    aksi
  end

  before(:each) do
    sasarans_gender

    login_as(user)
    visit root_path

    create_cookie('opd', 'test_opd')
    create_cookie('tahun', '2022')
  end

  scenario 'User fill GAP Form', js: true do
    visit new_gender_path
    select2 'Test Sub', from: 'SubKegiatan', search: true, match: :first
    expect(page).to have_field('Sasaran subkegiatan', with: 'contoh sasaran_kinerja')
    expect(page).to have_field('Penerima manfaat', with: 'contoh penerima_manfaat')
    expect(page).to have_field('Data terpilah', with: 'Data Terpilah')
    within('div#data-fill') do
      fill_in('Akses', with: 'Contoh Data Akses Gender')
      fill_in('Partisipasi', with: 'Contoh Data Partisipasi Gender')
      fill_in('Kontrol', with: 'Contoh Data Kontrol Gender')
      fill_in('Manfaat', with: 'Contoh Data Manfaat Gender')
    end
    fill_in('Penyebab internal', with: 'Contoh Data Penyebab Internal Gender')
    fill_in('Penyebab external', with: 'Contoh Data Penyebab External Gender')
    fill_in('Reformulasi tujuan', with: 'Contoh Data Reformulasi Tujuan Gender')
    fill_in('Sasaran subkegiatan', with: 'Contoh Data Sasaran Subkegiatan Gender')
    fill_in('Penerima manfaat', with: 'Contoh Data Penerima Manfaat Gender')
    fill_in('Data terpilah', with: 'Contoh Data Terpilah Gender')

    expect(page).to have_text("Rencana Aksi dan Anggaran #{sasaran}")
    expect(page).to have_text(tahapan.tahapan_kerja)
    expect(page).to have_text(20)

    find("input[type=checkbox]").click

    fill_in('Indikator', with: 'Contoh Data Indikator Gender')
    fill_in('Target', with: 'Contoh Data Target Indikator Gender')
    fill_in('Satuan', with: 'Contoh Data Satuan Gender')

    click_button('Simpan Gender Analysis Pathway')

    visit gap_genders_path
    expect(page).to have_content('Contoh Data Akses Gender')
  end
end
