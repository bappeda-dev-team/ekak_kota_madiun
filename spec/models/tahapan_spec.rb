# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  id_rencana       :string
#  id_rencana_aksi  :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  metadata         :jsonb
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  urutan           :string
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sasaran_id       :bigint
#
# Indexes
#
#  index_tahapans_on_id_rencana_aksi  (id_rencana_aksi) UNIQUE
#
require 'rails_helper'

RSpec.describe Tahapan, type: :model do
  context 'validation' do
    it { should validate_presence_of(:tahapan_kerja) }
  end

  context 'association' do
    it { should belong_to(:sasaran).optional }
    it { should have_many(:aksis) }
    it { should have_many(:anggarans) }
  end

  context 'get anggaran by tahapan' do
    context 'when tahapan have comment' do
      it 'should get all anggaran with comments only' do
        tahapan = Tahapan.create(tahapan_kerja: 'tahapan 1', sasaran_id: 1)
        user = FactoryBot.create(:user)
        anggaran = Anggaran.create!(tahapan_id: tahapan.id, jumlah: 100, uraian: 'Test Uraian')
        anggaran2 = Anggaran.create!(tahapan_id: tahapan.id, jumlah: 200, uraian: 'Test Uraian 2')
        anggaran3 = Anggaran.create!(tahapan_id: tahapan.id, jumlah: 300, uraian: 'Test Uraian 3')
        anggaran.update!(jumlah: 100)
        anggaran2.update!(jumlah: 200)
        anggaran.comments.create!(user_id: user.id, body: 'comment 1')
        anggaran2.comments.create!(user_id: user.id, body: 'comment 2')
        expect(tahapan.anggaran_tahapan_dengan_komentar).to eq([100, 200])
      end

      it 'should get all anggaran with comments only after comment removed' do
        tahapan = Tahapan.create(tahapan_kerja: 'tahapan 1', sasaran_id: 1)
        user = FactoryBot.create(:user)
        anggaran = Anggaran.create!(tahapan_id: tahapan.id, jumlah: 100, uraian: 'Test Uraian')
        anggaran2 = Anggaran.create!(tahapan_id: tahapan.id, jumlah: 200, uraian: 'Test Uraian 2')
        anggaran3 = Anggaran.create!(tahapan_id: tahapan.id, jumlah: 300, uraian: 'Test Uraian 3')
        anggaran.update!(jumlah: 100)
        anggaran2.update!(jumlah: 200)
        anggaran3.update!(jumlah: 300)
        anggaran.comments.create!(user_id: user.id, body: 'comment 1')
        anggaran2.comments.create!(user_id: user.id, body: 'comment 2')
        anggaran3.comments.create!(user_id: user.id, body: 'comment 2')
        expect(tahapan.anggaran_tahapan_dengan_komentar).to eq([100, 200, 300])
        anggaran3.comments.first.destroy!
        expect(tahapan.anggaran_tahapan_dengan_komentar).to eq([100, 200])
      end
    end
  end

  context 'Tahapan#grand_parent_anggaran' do
    it 'group anggaran by their grand_parent kode rekening' do
      tahapan = Tahapan.create(tahapan_kerja: 'tahapan 1', sasaran_id: 1)
      Anggaran.create!(tahapan_id: tahapan.id, jumlah: 100, uraian: 'Test Uraian', kode_rek: '23')
      Anggaran.create!(tahapan_id: tahapan.id, jumlah: 200, uraian: 'Test Uraian 2', kode_rek: '23')
      Anggaran.create!(tahapan_id: tahapan.id, jumlah: 300, uraian: 'Test Uraian 3', kode_rek: '23')
      Anggaran.create!(tahapan_id: tahapan.id, jumlah: 300, uraian: 'Test Uraian 3', kode_rek: '24')
      Rekening.create!(
        id: 23,
        kode_rekening: "5.1.02",
        jenis_rekening: "Parent Level 1"
      )
      Rekening.create!(
        id: 24,
        kode_rekening: "5.1.03",
        jenis_rekening: "Parent Level 1 lainnya"
      )
      grand_parent_anggaran = tahapan.grand_parent_anggaran
      jumlah_jenis_rekening = grand_parent_anggaran.size
      jumlah_rekening_pertama = grand_parent_anggaran["5.1.02"].size
      jumlah_rekening_kedua = grand_parent_anggaran["5.1.03"].size
      expect(jumlah_jenis_rekening).to eq(2)
      expect(jumlah_rekening_pertama).to eq(3)
      expect(jumlah_rekening_kedua).to eq(1)
    end
  end

  context 'Tahapan#jumlah_anggaran_grand_parent' do
    it 'array jumlah from same rekening' do
      tahapan = Tahapan.create(tahapan_kerja: 'tahapan 1', sasaran_id: 1)
      anggaran1 = Anggaran.create!(tahapan_id: tahapan.id, uraian: 'Test Uraian', kode_rek: '23')
      anggaran1.update!(jumlah: 200)
      anggaran2 = Anggaran.create!(tahapan_id: tahapan.id, uraian: 'Test Uraian 2', kode_rek: '23')
      anggaran2.update!(jumlah: 200)
      anggaran3 = Anggaran.create!(tahapan_id: tahapan.id, uraian: 'Test Uraian 3', kode_rek: '23')
      anggaran3.update!(jumlah: 200)
      Rekening.create!(
        id: 23,
        kode_rekening: "5.1.02",
        jenis_rekening: "Parent Level 1"
      )
      jumlah_anggaran = tahapan.jumlah_anggaran_grand_parent
      expect(jumlah_anggaran).to eq("5.1.02" => [200, 200, 200])
    end
  end

  context 'Tahapan#total_anggaran_grand_parent' do
    it 'sum array of jumlah_anggaran_grand_parent' do
      tahapan = Tahapan.create(tahapan_kerja: 'tahapan 1', sasaran_id: 1)
      anggaran1 = Anggaran.create!(tahapan_id: tahapan.id, uraian: 'Test Uraian', kode_rek: '23')
      anggaran1.update!(jumlah: 200)
      anggaran2 = Anggaran.create!(tahapan_id: tahapan.id, uraian: 'Test Uraian 2', kode_rek: '23')
      anggaran2.update!(jumlah: 200)
      anggaran3 = Anggaran.create!(tahapan_id: tahapan.id, uraian: 'Test Uraian 3', kode_rek: '23')
      anggaran3.update!(jumlah: 200)
      Rekening.create!(
        id: 23,
        kode_rekening: "5.1.02",
        jenis_rekening: "Parent Level 1"
      )
      jumlah_anggaran = tahapan.total_anggaran_grand_parent
      expect(jumlah_anggaran).to eq("5.1.02" => 600)
    end
  end
end
