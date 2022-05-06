# == Schema Information
#
# Table name: perhitungans
#
#  id          :bigint           not null, primary key
#  deskripsi   :string
#  harga       :integer
#  satuan      :string
#  spesifikasi :text
#  total       :integer
#  volume      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint
#  pajak_id    :bigint
#
# Indexes
#
#  index_perhitungans_on_anggaran_id  (anggaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id) ON DELETE => nullify
#
require 'rails_helper'

RSpec.describe Perhitungan, type: :model do
  let(:pajak) { FactoryBot.create(:pajak) }
  let(:pajak0) { FactoryBot.create(:pajak, potongan: 0) }
  let(:anggaran) { FactoryBot.build(:anggaran) }
  let(:perhitungan) { FactoryBot.build(:perhitungan) }
  let(:koefisien) { FactoryBot.build(:koefisien) }

  context 'validation' do
    it { should validate_presence_of(:deskripsi) }
    it { should validate_presence_of(:satuan) }
    it { should validate_presence_of(:harga) }
    it { should validate_numericality_of(:harga) }
    it { should belong_to(:pajak).optional(true) }
  end

  context 'association' do
    it { should belong_to(:anggaran) }
    it { should have_many(:koefisiens) }
    it { should accept_nested_attributes_for(:koefisiens) }
  end

  describe 'Perhitungan#hitung_total' do
    it 'checking bot delete later' do
      anggaran.pajak = pajak0
      expect(pajak0.potongan).to eq(0.0)
      expect(anggaran.pajak.potongan).to eq(0.0)
      expect(perhitungan.anggaran.kode_rek).to eq('5.1.01.03.07.0001')
      expect(perhitungan.harga).to eq(1_000_000)
      expect(koefisien.volume).to eq(5)
    end

    it 'calculate perhitungan total tanpa pajak' do
      anggaran.pajak = pajak0
      perhitungan = Perhitungan.create(anggaran: anggaran, deskripsi: 'contoh', satuan: 'Orang', harga: 1_000_000)
      perhitungan.koefisiens.build(volume: 5, satuan_volume: 'Orang')
      perhitungan.hitung_total
      expect(perhitungan.total).to eq(5_000_000)
    end

    it 'calculate perhitungan total dengan pajak' do
      perhitungan = Perhitungan.create(anggaran: anggaran, deskripsi: 'contoh', satuan: 'Orang', harga: 1_000_000)
      perhitungan.koefisiens.build(volume: 5, satuan_volume: 'Orang')
      perhitungan.hitung_total
      expect(anggaran.pajak.potongan).to eq(0.1)
      expect(perhitungan.total).to eq(5_500_000)
    end

    it 'using pajak inside perhitungan' do
      perhitungan = Perhitungan.create(anggaran: anggaran, deskripsi: 'contoh', satuan: 'Orang', harga: 1_000_000)
      perhitungan.koefisiens.build(volume: 5, satuan_volume: 'Orang')
      perhitungan.pajak = pajak
      expect(perhitungan.pajak.potongan).to eq(0.1)
    end
    it 'hitung total using pajak inside perhitungan' do
      perhitungan = Perhitungan.create(anggaran: anggaran, deskripsi: 'contoh', satuan: 'Orang', harga: 1_000_000)
      perhitungan.koefisiens.build(volume: 5, satuan_volume: 'Orang')
      perhitungan.pajak = pajak
      perhitungan.hitung_total
      expect(perhitungan.total).to eq(5_500_000)
    end
  end
end
