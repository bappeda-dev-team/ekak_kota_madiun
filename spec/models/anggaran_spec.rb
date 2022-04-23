# frozen_string_literal: true

# == Schema Information
#
# Table name: anggarans
#
#  id         :bigint           not null, primary key
#  jumlah     :integer
#  kode_rek   :string
#  level      :integer          default(0)
#  set_input  :string           default("0")
#  tahun      :integer
#  uraian     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pajak_id   :bigint
#  parent_id  :bigint
#  tahapan_id :bigint
#
# Indexes
#
#  index_anggarans_on_pajak_id    (pajak_id)
#  index_anggarans_on_parent_id   (parent_id)
#  index_anggarans_on_tahapan_id  (tahapan_id)
#
# Foreign Keys
#
#  fk_rails_...  (pajak_id => pajaks.id)
#
require 'rails_helper'

RSpec.describe Anggaran, type: :model do
  context 'validation' do
    it { should validate_presence_of(:uraian) }
  end

  context 'association' do
    it { should belong_to(:tahapan) }
    it { should belong_to(:pajak).optional(true) }
    it { should have_many(:perhitungans) }
  end

  context 'parent-child' do
    it { should belong_to(:parent).class_name('Anggaran').optional }
    it { should have_many(:childs).class_name('Anggaran') }
  end

  describe 'Anggaran#update_perhitungan' do
    let(:anggaran) { create(:anggaran) }
    let(:pajak) { create(:pajak, potongan: 0.11) }
    let(:pajak0) { create(:pajak, potongan: 0) }
    it 'should update perhitungan with pajak 11%' do
      anggaran.perhitungans.create(deskripsi: '1.1.7.01.01.01.002', satuan: 'orang', harga: 1_000_000, pajak: pajak)
      koef_update = anggaran.perhitungans.first.koefisiens.create(satuan_volume: 'Orang', volume: 1)
      expect(anggaran).to be_valid
      expect(koef_update).to be_valid
      anggaran.update_perhitungan
      expect(anggaran.reload.jumlah).to eq(1_100_000)
    end
  end

  describe 'Anggaran#perhitungan_jumlah' do
    let(:anggaran) { create(:anggaran) }
    let(:pajak) { create(:pajak, potongan: 0.11) }
    let(:pajak0) { create(:pajak, potongan: 0) }
    it 'should update perhitungan with pajak 0' do
      anggaran.perhitungans.create(deskripsi: '1.1.7.01.01.01.002', satuan: 'orang', harga: 1_000_000, pajak: pajak0)
      anggaran.perhitungans.first.koefisiens.create(satuan_volume: 'Orang', volume: 1)
      anggaran.reload
      anggaran.perhitungan_jumlah
      expect(anggaran.jumlah).to eq(1_000_000)
    end

    it 'should update perhitungan with pajak 11%' do
      anggaran.perhitungans.create(deskripsi: '1.1.7.01.01.01.002', satuan: 'orang', harga: 500000, pajak: pajak)
      anggaran.perhitungans.first.koefisiens.create(satuan_volume: 'Orang', volume: 5)
      anggaran.reload
      anggaran.perhitungan_jumlah
      expect(anggaran.jumlah).to eq(277_500_0)
    end
  end
end
