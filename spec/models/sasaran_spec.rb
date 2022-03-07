# == Schema Information
#
# Table name: sasarans
#
#  id                  :bigint           not null, primary key
#  anggaran            :integer
#  indikator_kinerja   :string
#  kualitas            :integer
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
require 'rails_helper'

RSpec.describe Sasaran, type: :model do
  let(:lembaga) { Lembaga.create!(nama_lembaga: 'Kota Madiun', tahun: '2022') }
  let(:opd) do
    Opd.create!(nama_opd: 'Dinas Komunikasi dan Informatika', kode_opd: '2.16.2.20.2.21.04.000', lembaga_id: lembaga.id)
  end
  let(:user) do
    User.create!(nama: 'NOOR AFLAH', nik: '197609072003121007', kode_opd: opd.kode_opd,
                 email: '197609072003121007@madiunkota.go.id', password: '123456')
  end

  def sasaran_base
    Sasaran.create(
      sasaran_kinerja: 'Meningkatnya kualitas dokumen perencanaan, penganggaran, pengendalian dan evaluasi perangkat daerah',
      indikator_kinerja: 'presentase penyusunan dokumen perencanaan, penganggaran, pengendalian dan evaluasi PD tepat waktu',
      target: 100,
      satuan: '%',
      user_id: user.id
    )
  end

  def tahapan_base
    Tahapan.create(
      tahapan_kerja: 'Tahapan Testing',
      keterangan: 'Keterangan buatan'
    )
  end
  context 'punya pak aflah' do
    let(:s_kerja) do
      'Meningkatnya kualitas dokumen perencanaan, penganggaran, pengendalian dan evaluasi perangkat daerah'
    end
    let(:i_kerja) do
      'presentase penyusunan dokumen perencanaan, penganggaran, pengendalian dan evaluasi PD tepat waktu'
    end
    let(:target) { '100' }
    let(:satuan) { '%' }
    let(:u_kerja) { user.id }

    it 'is valid with a sasaran, indikator, target, and satuan' do
      sasaran = Sasaran.create(
        sasaran_kinerja: s_kerja,
        indikator_kinerja: i_kerja,
        target: target,
        satuan: satuan,
        user_id: u_kerja
      )
      expect(sasaran).to be_valid
    end
    it 'is not valid without a sasaran' do
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

    it 'is not valid without a indikator' do
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

    it 'is not valid without target' do
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

    it 'is not valid without satuan' do
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

    it 'is valid with duplicate' do
      Sasaran.create!(
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

  context 'sudah terisi dan menambah subkegiatan' do
    it 'can update subkegiatan from local record' do
      sas = FactoryBot.build(:sasaran)
      program = FactoryBot.build(:program_kegiatan)
      sas.program_kegiatan = program
      sas.build
      expect(sas).to be_valid
    end
  end

  context 'Sasaran#Tahapans' do
    it 'can add tahapans to sasaran' do
      sasaran = FactoryBot.build(:sasaran)
      tahapan = tahapan_base
      sasaran.tahapan = tahapan
      sasaran.save
      expect(sasaran).to be_valid
    end
  end

  context 'association' do
    it { should have_many(:musrenbangs) }
    it { should have_many(:pokpirs) }
    it { should have_many(:mandatoris) }
    it { should have_many(:inovasis) }
    it { should have_many(:tahapans) }
    it { should have_one(:rincian) }
    it { should belong_to(:user) }
    it { should belong_to(:program_kegiatan).optional }
  end

  context 'nested_attribute' do
    it { should accept_nested_attributes_for(:rincian).update_only(true) }
    it { should accept_nested_attributes_for(:tahapans) }
  end
end
