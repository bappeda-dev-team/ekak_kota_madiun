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
FactoryBot.define do
  factory :opd do
    nama_opd { "Dinas Komunikasi dan Informatika" }
    kode_opd { "2.16.2.20.2.21.04.000" }
    kode_unik_opd { "test_opd" }
    association :lembaga
  end
end
