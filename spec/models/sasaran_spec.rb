# == Schema Information
#
# Table name: sasarans
#
#  id                  :bigint           not null, primary key
#  anggaran            :integer
#  indikator_kinerja   :string
#  kualitas            :integer
#  nip_asn             :string
#  penerima_manfaat    :string
#  sasaran_kinerja     :string
#  satuan              :string
#  target              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_sasarans_on_program_kegiatan_id  (program_kegiatan_id)
#  index_sasarans_on_user_id              (user_id)
#
require "rails_helper"

RSpec.describe Sasaran, type: :model do
  let(:lembaga) { Lembaga.create!(nama_lembaga: "Kota Madiun", tahun: "2022") }
  let(:opd) { Opd.create!(nama_opd: "Dinas Komunikasi dan Informatika", kode_opd: "2.16.2.20.2.21.04.000", lembaga_id: lembaga.id) }
  let(:user) { User.create!(nama: "NOOR AFLAH", nik: "197609072003121007", opd_id: opd.id, email: "197609072003121007@madiunkota.go.id", password: "123456") }

  def sasaran_base
    Sasaran.create(
        sasaran_kinerja: "Meningkatnya kualitas dokumen perencanaan, penganggaran, pengendalian dan evaluasi perangkat daerah",
        indikator_kinerja: "presentase penyusunan dokumen perencanaan, penganggaran, pengendalian dan evaluasi PD tepat waktu",
        target: 100 ,
        satuan: "%",
        user_id: user.id,
      )
  end
  def tahapan_base
    Tahapan.create(
      tahapan_kerja: "Tahapan Testing",
      keterangan: "Keterangan buatan"
    )
  end
  context "punya pak aflah" do
    let(:s_kerja) { "Meningkatnya kualitas dokumen perencanaan, penganggaran, pengendalian dan evaluasi perangkat daerah" }
    let(:i_kerja) { "presentase penyusunan dokumen perencanaan, penganggaran, pengendalian dan evaluasi PD tepat waktu" }
    let(:target) { "100" }
    let(:satuan) { "%" }
    let(:u_kerja) { user.id }

    it "is valid with a sasaran, indikator, target, and satuan" do
      sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja,
      )
      expect(sasaran).to be_valid
    end
    it "is not valid without a sasaran" do
      sasaran = Sasaran.create(
        sasaran_kinerja: nil,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja,
      )
      expect(sasaran).to_not be_valid
      expect(sasaran.errors[:sasaran_kinerja]).to include("can't be blank")
    end

    it "is not valid without a indikator" do
      sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: nil,
        target: target,
        satuan: satuan,
        user_id: u_kerja,
      )
      expect(sasaran).to_not be_valid
      expect(sasaran.errors[:indikator_kinerja]).to include("can't be blank")
    end

    it "is not valid without target" do
      sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: nil,
        satuan: satuan,
        user_id: u_kerja,
      )
      expect(sasaran).to_not be_valid
      expect(sasaran.errors[:target]).to include("can't be blank")
    end

    it "is not valid without satuan" do
      sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: nil,
        user_id: u_kerja,
      )
      expect(sasaran).to_not be_valid
      expect(sasaran.errors[:satuan]).to include("can't be blank")
    end

    it "is valid with duplicate" do
      Sasaran.create!(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja,
      )
      sasaran_2 = sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja,
      )
      expect(sasaran_2).to be_valid
    end
  end

  context "sudah terisi dan menambah subkegiatan" do
    it "can update subkegiatan from local record" do
      sas = FactoryBot.build(:sasaran)
      program = FactoryBot.build(:program_kegiatan)
      sas.program_kegiatan = program
      sas.save
      expect(sas).to be_valid
    end
  end

  context "Sasaran#Tahapans" do
    it "can add tahapans to sasaran" do
      sasaran = FactoryBot.build(:sasaran)
      tahapan = tahapan_base
      sasaran.tahapan = tahapan
      sasaran.save
      expect(sasaran).to be_valid
    end
  end
end
