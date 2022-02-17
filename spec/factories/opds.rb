# == Schema Information
#
# Table name: opds
#
#  id            :bigint           not null, primary key
#  id_opd_skp    :integer
#  kode_opd      :string
#  kode_unik_opd :string
#  nama_opd      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lembaga_id    :integer
#
# Indexes
#
#  index_opds_on_kode_opd  (kode_opd) UNIQUE
#
FactoryBot.define do
  factory :opd do
    nama_opd { "Dinas Komunikasi dan Informatika" }
    kode_opd { "2.16.2.20.2.21.04.000" }
    association :lembaga
  end
end
