require 'rails_helper'

RSpec.describe PaguService, type: :model do
  subject { described_class.new(tahun: '2024', jenis: 'ranwal') }

  context 'opd dan program kegiatan' do
    it 'menampilkan seluruh opd dalam kota' do
      contoh_opds = [
        create(:opd, nama_opd: 'OPD A', kode_unik_opd: '123.111'),
        create(:opd, nama_opd: 'OPD B', kode_unik_opd: '123.222'),
        create(:opd, nama_opd: 'OPD C', kode_unik_opd: '123.333')
      ]
      expect(subject.opds).to eq(contoh_opds)
    end

    it 'menampilkan program per opd' do
      opd_a = create(:opd, nama_opd: 'OPD A', kode_unik_opd: '123.111')
      create(:program_kegiatan,
             nama_program: 'Program A',
             kode_program: '1.02.111',
             kode_skpd: '123.111',
             kode_sub_skpd: '123.111',
             opd: opd_a)
      opd_b = create(:opd, nama_opd: 'OPD B', kode_unik_opd: '123.222')
      create(:program_kegiatan,
             nama_program: 'Program B',
             kode_program: '1.02.222',
             kode_skpd: '123.222',
             kode_sub_skpd: '123.222',
             opd: opd_b)
      contoh_programs = [
        {
          nama_opd: 'OPD A',
          kode_opd: '123.111',
          programs: [
            {
              jenis: 'program',
              nama: 'Program A',
              kode: '1.02.111'
            }
          ]
        },
        {
          nama_opd: 'OPD B',
          kode_opd: '123.222',
          programs: [
            {
              jenis: 'program',
              nama: 'Program B',
              kode: '1.02.222'
            }
          ]
        }
      ]
      expect(subject.program_opd).to eq(contoh_programs)
    end
  end
end
