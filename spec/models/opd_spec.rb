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
    it { should validate_presence_of(:nama_opd)  }
    it { should validate_presence_of(:kode_opd)  }
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
end
