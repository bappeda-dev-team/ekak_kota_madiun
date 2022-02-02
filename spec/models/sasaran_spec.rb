require 'rails_helper'

RSpec.describe Sasaran, type: :model do
  let(:lembaga) {Lembaga.create!(nama_lembaga: "Kota Madiun", tahun: "2022")}
  let(:opd) { Opd.create!( nama_opd: 'Dinas Komunikasi dan Informatika', kode_opd: '2.16.2.20.2.21.04.000', lembaga_id: lembaga.id) }
  let(:user) { User.create!(nama: 'NOOR AFLAH', nik: '197609072003121007', opd_id: opd.id, email: '197609072003121007@madiunkota.go.id', password: '123456') }
  
  context "punya pak aflah" do
    let(:s_kerja){ "Meningkatnya kualitas dokumen perencanaan, penganggaran, pengendalian dan evaluasi perangkat daerah"}
    let(:i_kerja) {"presentase penyusunan dokumen perencanaan, penganggaran, pengendalian dan evaluasi PD tepat waktu"}
    let(:target) {"100"}
    let(:satuan) {"%"}
    let(:u_kerja) {user.id}

    it "is valid with a sasaran, indikator, target, and satuan" do
      sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja
      )
      expect(sasaran).to be_valid
    end
    it "is not valid without a sasaran" do
      sasaran = Sasaran.create(
        sasaran_kinerja: nil,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja
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
        user_id: u_kerja
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
        user_id: u_kerja
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
        user_id: u_kerja
      )
      expect(sasaran).to_not be_valid
      expect(sasaran.errors[:satuan]).to include("can't be blank")
    end
    
    it "is valid with duplicate" do
      sasaran_1 = Sasaran.new(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja
      )
      sasaran_2 = sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja
      )
      expect(sasaran_2).to be_valid
    end
  end




  # pending "tells the sasaran is duplicated"

end