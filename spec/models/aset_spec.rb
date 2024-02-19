# == Schema Information
#
# Table name: asets
#
#  id            :bigint           not null, primary key
#  jumlah        :integer
#  keterangan    :string
#  kode_unik_opd :string
#  kondisi       :text             default([]), is an Array
#  nama_aset     :string
#  satuan        :string
#  tahun_akhir   :integer
#  tahun_awal    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Aset, type: :model do
  context 'validation' do
    it { should validate_presence_of(:nama_aset) }
    it { should validate_presence_of(:jumlah) }
    it { should validate_numericality_of(:jumlah).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:satuan) }

    it { should belong_to(:opd) }
  end
  context 'kondisi aset' do
    it 'return kondisi in Array' do
      aset_baik = Aset.create(nama_aset: 'Test',
                              kondisi: ['Baik'],
                              tahun_awal: 2019,
                              tahun_akhir: 2023)
      expect(aset_baik.kondisi).to eq(['Baik'])
    end
    it 'return true for Baik' do
      aset_baik = Aset.create(nama_aset: 'Test',
                              kondisi: ['Baik'],
                              tahun_awal: 2019,
                              tahun_akhir: 2023)
      expect(aset_baik.kondisi.include?('Baik')).to be true
    end
  end

  describe '#perolehan_aset' do
    context 'dengan tahun awal dan akhir' do
      it 'return string from awal-akhir range' do
        aset_2019_2023 = Aset.create(nama_aset: 'Test',
                                     kondisi: ['Baik'],
                                     tahun_awal: 2019,
                                     tahun_akhir: 2023)
        expect(aset_2019_2023.perolehan_aset).to eq('2019, 2020, 2021, 2022, 2023')
      end
    end
  end
end
