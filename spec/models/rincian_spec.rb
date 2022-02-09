# == Schema Information
#
# Table name: rincians
#
#  id                  :bigint           not null, primary key
#  data_terpilah       :string
#  lokasi_pelaksanaan  :string
#  penyebab_external   :string
#  penyebab_internal   :string
#  permasalahan_gender :string
#  permasalahan_umum   :string
#  resiko              :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  sasaran_id          :bigint           not null
#
# Indexes
#
#  index_rincians_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
require 'rails_helper'

RSpec.describe Rincian, type: :model do

    let(:lembaga) {Lembaga.create!(nama_lembaga: "Kota Madiun", tahun: "2022")}
    let(:opd) { Opd.create!( nama_opd: 'Dinas Komunikasi dan Informatika', kode_opd: '2.16.2.20.2.21.04.000', lembaga_id: lembaga.id) }
    let(:user) { User.create!(nama: 'NOOR AFLAH', nik: '197609072003121007', opd_id: opd.id, email: '197609072003121007@madiunkota.go.id', password: '123456') }  

  context "punya pak Aflah" do
    it "invalid tanpa sasaran" do
      rincian = Rincian.create(data_terpilah: "Data Terpilah A")
      expect(rincian).to_not be_valid
    end
  end

  context "pak Aflah dengan sasaran" do
    let(:s_kerja){ "Meningkatnya kualitas dokumen perencanaan, penganggaran, pengendalian dan evaluasi perangkat daerah"}
    let(:i_kerja) {"presentase penyusunan dokumen perencanaan, penganggaran, pengendalian dan evaluasi PD tepat waktu"}
    let(:target) {"100"}
    let(:satuan) {"%"}
    let(:u_kerja) {user.id}
    let(:sas) { Sasaran.create(
      sasaran_kinerja: s_kerja,
      indikator_kinerja: i_kerja,
      target: target,
      satuan: satuan,
      user_id: u_kerja
    ) }
    it "valid with sasaran" do
      rincian = sas.create_rincian(data_terpilah: 'Data Terpilah ABC', lokasi_pelaksanaan: "Kota Madiun")
      expect(rincian).to be_valid
    end

    it "invalid without lokasi_pelaksanaan" do
      rincian = sas.create_rincian(data_terpilah: 'Data Terpilah ABC', lokasi_pelaksanaan: nil)
      expect(rincian).to_not be_valid
    end

    it "show error when invalid without lokasi_pelaksanaan" do
      rincian = sas.create_rincian(data_terpilah: 'Data Terpilah ABC', lokasi_pelaksanaan: nil)
      expect(rincian.errors[:lokasi_pelaksanaan]).to include("can't be blank")
    end
  end
end
