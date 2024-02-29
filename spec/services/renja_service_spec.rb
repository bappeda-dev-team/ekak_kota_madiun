require 'rails_helper'

RSpec.describe RenjaService do
  subject { described_class.new(kode_opd: '1.23.456', tahun: '2024') }

  let(:opd) { create(:opd, kode_unik_opd: '1.23.456') }

  context 'program kegiatan subkegiatan' do
    it 'get program in opd' do
      create(:program_kegiatan, opd: opd,
                                kode_skpd: opd.kode_unik_opd,
                                kode_sub_skpd: opd.kode_unik_opd,
                                kode_bidang_urusan: '1',
                                kode_program: '1.01',
                                nama_program: 'test program')
      create(:program_kegiatan, opd: opd,
                                kode_skpd: opd.kode_unik_opd,
                                kode_sub_skpd: opd.kode_unik_opd,
                                kode_bidang_urusan: '1',
                                kode_program: '1.02',
                                nama_program: 'test program 2')
      programs = [
        { jenis: 'program',
          parent: '1',
          kode_opd: '1.23.456',
          kode: '1.01',
          nama: 'test program' },
        { jenis: 'program',
          parent: '1',
          kode_opd: '1.23.456',
          kode: '1.02',
          nama: 'test program 2' }
      ]
      expect(subject.program_renja).to eq(programs)
    end
    it 'get kegiatan in opd' do
      create(:program_kegiatan, opd: opd,
                                kode_skpd: opd.kode_unik_opd,
                                kode_sub_skpd: opd.kode_unik_opd,
                                kode_program: '1.01',
                                kode_giat: '1.01.1.01',
                                nama_kegiatan: 'test kegiatan')
      kegiatans = [
        { jenis: 'kegiatan',
          parent: '1.01',
          kode_opd: '1.23.456',
          kode: '1.01.1.01',
          nama: 'test kegiatan' }
      ]
      expect(subject.kegiatan_renja).to eq(kegiatans)
    end

    it 'get subkegiatan in opd' do
      create(:program_kegiatan, opd: opd,
                                kode_skpd: opd.kode_unik_opd,
                                kode_sub_skpd: opd.kode_unik_opd,
                                kode_giat: '1.01.1.01',
                                kode_sub_giat: '1.01.1.01.1.23.45',
                                nama_subkegiatan: 'test subkegiatan')
      subkegiatans = [
        { jenis: 'subkegiatan',
          parent: '1.01.1.01',
          kode_opd: '1.23.456',
          kode: '1.01.1.01.1.23.45',
          nama: 'test subkegiatan' }
      ]
      expect(subject.subkegiatan_renja).to eq(subkegiatans)
    end
  end

  context 'indikator dan pagu' do
    it 'memunculkan pagu indikator subkegiatan' do
      create(:indikator, jenis: 'Renstra',
                         sub_jenis: 'Subkegiatan',
                         tahun: '2024',
                         pagu: 50_000,
                         version: 0,
                         kotak: 0,
                         kode: '123.456',
                         kode_opd: '1.23.456')
      expect(subject.pagu_subkegiatan('123.456')).to eq(50_000)
    end

    it 'pagu 0 untuk selain ranwal rancangan rankir' do
      contoh = described_class.new(kode_opd: '1.23.456',
                                   tahun: '2024',
                                   jenis: 'tidak diketahui')
      expect(contoh.pagu_subkegiatan('123')).to eq 0
    end
  end
end
