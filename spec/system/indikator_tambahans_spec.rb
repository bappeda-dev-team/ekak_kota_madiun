require 'rails_helper'

RSpec.describe "IndikatorTambahans", type: :system do
  let(:user) { create(:super_admin) }

  context 'indikator rkpd' do
    it 'display indikator tujuan, sasaran and program by bidang urusan opd' do
      opd = create(:opd,
                   nama_opd: 'Dinas A',
                   kode_opd: '123',
                   kode_unik_opd: 'test_opd')
      tujuan = create(:tujuan,
                      tujuan: 'Tujuan A',
                      type: 'TujuanOpd',
                      tahun_awal: '2025',
                      tahun_akhir: '2026',
                      id_tujuan: 'test_tujuan',
                      kode_unik_opd: opd.kode_unik_opd)
      ind_tujuan = create(:indikator,
                          indikator: 'indikator a',
                          jenis: 'Tujuan',
                          sub_jenis: 'Opd',
                          kode: 'test_tujuan')
      program = create(:program_kegiatan,
                       nama_program: 'Program A',
                       kode_opd: '123')

      login_as user
      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')

      visit rkpd_indikators_path

      expect(page).to have_content(opd.nama_opd)
      expect(page).to have_content(tujuan.tujuan)
      expect(page).to have_text('indikator a')
      # expect(page).to have_content(program.nama_program)
    end
  end
end
