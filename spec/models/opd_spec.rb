# == Schema Information
#
# Table name: opds
#
#  id                 :bigint           not null, primary key
#  bidang_urusan      :string
#  has_bidang         :boolean          default(FALSE)
#  id_bidang          :integer
#  id_daerah          :string
#  id_opd_skp         :integer
#  is_bidang          :boolean          default(FALSE)
#  kode_bidang_urusan :string
#  kode_opd           :string
#  kode_opd_induk     :string
#  kode_unik_opd      :string
#  kode_urusan        :string
#  nama_kepala        :string
#  nama_opd           :string
#  nip_kepala         :string
#  pangkat_kepala     :string
#  status_kepala      :string
#  tahun              :string
#  urusan             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lembaga_id         :integer
#
# Indexes
#
#  index_opds_on_kode_unik_opd_and_lembaga_id  (kode_unik_opd,lembaga_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Opd, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:nama_opd) }
  end

  describe 'urusan dan bidang urusan' do
    it 'should separate first 15 kode_unik_opd' do
      opd = create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')
      kode_urusans = opd.kode_urusans
      expect(kode_urusans).to include('2.16', '2.20', '2.21')
    end

    it 'should list urusan by kode_urusans' do
      bidang_urusan = create(:master_urusan)
      list_urusan = [[bidang_urusan.kode_urusan, bidang_urusan.nama_urusan]]
      opd = create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')
      urusans = opd.list_urusans
      expect(urusans).to eq(list_urusan)
    end

    it 'should list bidang urusan by kode_urusans' do
      bidang_urusan = create(:master_bidang_urusan)
      bidang_urusan2 = create(:master_bidang_urusan, id_unik_sipd: '1.2',
                                                     kode_bidang_urusan: '2.20',
                                                     nama_bidang_urusan: 'URUSAN PEMERINTAHAN BIDANG STATISTIK')
      list_bidang_urusan = [[bidang_urusan.kode_bidang_urusan, bidang_urusan.nama_bidang_urusan],
                            [bidang_urusan2.kode_bidang_urusan, bidang_urusan2.nama_bidang_urusan]]
      opd = create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')
      bidang_urusans = opd.list_bidang_urusans
      expect(bidang_urusans).to eq(list_bidang_urusan)
    end
  end

  describe 'get subkegiatan by sasaran asn' do
    context 'sasaran complete' do
      it 'should list subkegiatan by tahun sasaran' do
        tahun = '2023'
        user = create(:eselon_4)
        program = create(:program_kegiatan, opd: user.opd)
        strategi = create(:strategi, tahun: '2023', role: 'eselon_4', nip_asn: user.nik)
        create(:sasaran_subkegiatan, user: user, tahun: '2023', program_kegiatan: program, strategi_id: strategi.id)
        opd = user.opd
        subkegiatan = opd.sasaran_subkegiatans(tahun)

        expect(subkegiatan.size).to eq 1
        expect(subkegiatan).to include program
      end
      it 'should list subkegiatan by multiple tahun' do
        periode = (2023..2024)
        user = create(:eselon_4)
        program = create(:program_kegiatan, opd: user.opd)
        strategi = create(:strategi, tahun: '2023', role: 'eselon_4', nip_asn: user.nik)
        strategi2 = create(:strategi, tahun: '2024', role: 'eselon_4', nip_asn: user.nik)
        create(:sasaran_subkegiatan, user: user, tahun: '2023', program_kegiatan: program, strategi_id: strategi.id)
        create(:sasaran_subkegiatan, user: user, tahun: '2024', program_kegiatan: program, strategi_id: strategi2.id)
        opd = user.opd
        subkegiatans = periode.map { |tahun| opd.sasaran_subkegiatans(tahun) }.uniq

        expect(subkegiatans.size).to eq 1
      end
    end
    context 'sasaran incomplete' do
      it 'should not list sasaran by tahun' do
        tahun = '2023'
        user = create(:eselon_4)
        create(:program_kegiatan, opd: user.opd)
        strategi = create(:strategi, tahun: '2023', role: 'eselon_4', nip_asn: user.nik)
        create(:sasaran, user: user, tahun: '2023', strategi_id: strategi.id)
        opd = user.opd
        subkegiatan = opd.sasaran_subkegiatans(tahun)

        expect(subkegiatan.size).to eq 0
      end
    end
  end

  describe '#kode_opd_unik' do
    it 'show kode unik opd with no child' do
      kominfo = create(:opd, kode_unik_opd: '2.16.2.20.2.21.04.000')
      expect(kominfo.kode_opd_unik).to include('2.16.2.20.2.21.04.000')
    end

    it 'show kode opd from their child opd too' do
      kecamatan = create(:opd, kode_unik_opd: '7.01.0.00.0.00.02.0000')
      kelurahan = create(:opd, kode_unik_opd: '7.01.0.00.0.00.02.0007')
      expect(kecamatan.kode_opd_unik).to eq(['7.01.0.00.0.00.02.0000',
                                             '7.01.0.00.0.00.02.0007'])
    end
  end
end
