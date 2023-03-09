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
end
