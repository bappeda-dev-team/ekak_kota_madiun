# == Schema Information
#
# Table name: anggaran_bluds
#
#  id                     :bigint           not null, primary key
#  harga_satuan           :bigint
#  kode_barang            :string
#  kode_kelompok_barang   :string
#  satuan                 :string
#  spesifikasi            :string
#  uraian_barang          :string
#  uraian_kelompok_barang :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

RSpec.describe AnggaranBlud, type: :model do
  let(:anggaran_blud) do
    AnggaranBlud.create(
      harga_satuan: 100_000_000,
      kode_barang: '01',
      kode_kelompok_barang: '01.01',
      satuan: 'buah',
      spesifikasi: 'bahan kimia habis pakai',
      uraian_barang: 'bahan kimia',
      uraian_kelompok_barang: 'bahan kimia medis'
    )
  end
  context 'basic crud' do
    it 'can create with valid parameter' do
      expect(anggaran_blud).to be_valid
    end

    it 'can update with valid parameter' do
      anggaran_blud.update(:uraian_barang => 'bahan kimia medis update')
      expect(anggaran_blud).to be_valid
      expect(anggaran_blud.uraian_barang).to eq('bahan kimia medis update')
    end

    it 'can destroy with valid parameter' do
      anggaran_blud
      expect { anggaran_blud.destroy }.to change { AnggaranBlud.count }.by(-1)
      expect { anggaran_blud.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'show anggaran when called' do
      anggaran_blud
      expect(anggaran_blud.uraian_barang).to eq('bahan kimia')
    end
  end

  context 'validation like another anggarans' do
    it { should validate_presence_of(:kode_barang) }
    it { should validate_presence_of(:kode_kelompok_barang) }
    it { should validate_presence_of(:uraian_barang) }
    it { should validate_numericality_of(:harga_satuan) }
  end
end
