require 'rails_helper'

RSpec.describe "IndikatorTambahans", type: :system do
  let(:es2) { create(:eselon_2) }

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
      # strategi bertumpuk dari eselon 2 ke 4
      strategi = create(:strategi,
                        opd: opd,
                        tujuan: tujuan,
                        role: 'eselon_2',
                        strategi: 'test strategi')
      strategi_es3 = create(:strategi,
                            opd: opd,
                            role: 'eselon_3',
                            strategi_ref_id: strategi.id,
                            strategi: 'test tactical')
      strategi_es4 = create(:strategi,
                            opd: opd,
                            role: 'eselon_4',
                            strategi_ref_id: strategi_es3.id,
                            strategi: 'test operational')
      # sasaran opd, dari user eselon_2
      sasaran_opd = create(:sasaran,
                           strategi: strategi,
                           sasaran_kinerja: 'test abc',
                           user: es2)
      # eselon 4 buat sasaran, ambil strategi_es4 dan add subkegiatan ( program_kegiatan )
      es4 = create(:eselon_4, opd: opd, email: 'abcd@email.com', nik: '123_456_777')
      program = create(:program_kegiatan,
                       nama_program: 'Program A',
                       kode_opd: '123')
      sasaran_es4 = create(:sasaran,
                           strategi: strategi_es4,
                           sasaran_kinerja: 'test abcdef',
                           program_kegiatan: program,
                           user: es4)

      login_as es2
      visit root_path

      create_cookie('opd', 'test_opd')
      create_cookie('tahun', '2025')

      visit rkpd_indikators_path

      expect(page).to have_content(opd.nama_opd)
      expect(page).to have_content(tujuan.tujuan)
      expect(page).to have_text('indikator a')
      expect(page).to have_content(sasaran_opd.sasaran_kinerja)
      expect(page).to have_text('Program A')
    end
  end
end
