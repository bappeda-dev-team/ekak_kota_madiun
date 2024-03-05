require 'rails_helper'

RSpec.describe PaguService, type: :model do
  subject { described_class.new(tahun: '2025', jenis: 'ranwal') }

  context 'opd dan program kegiatan' do
    it 'menampilkan seluruh opd dalam kota' do
      contoh_opds = [
        create(:opd, nama_opd: 'OPD A', kode_unik_opd: '123.111'),
        create(:opd, nama_opd: 'OPD B', kode_unik_opd: '123.222'),
        create(:opd, nama_opd: 'OPD C', kode_unik_opd: '123.333')
      ]
      expect(subject.opds).to eq(contoh_opds)
    end

    it 'menampilkan jumlah program, kegiatan, subkegiatan per opd' do
      pending('map jumlah program, kegiatan subkegiatan')
    end
  end
end
