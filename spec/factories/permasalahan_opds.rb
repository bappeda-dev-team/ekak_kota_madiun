# == Schema Information
#
# Table name: permasalahan_opds
#
#  id                         :bigint           not null, primary key
#  faktor_penghambat_skp      :string
#  jenis                      :string
#  kode_opd                   :string
#  kode_permasalahan_external :string
#  permasalahan               :string
#  status                     :string
#  tahun                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  isu_strategis_opd_id       :bigint
#
# Indexes
#
#  index_permasalahan_opds_on_isu_strategis_opd_id  (isu_strategis_opd_id)
#
FactoryBot.define do
  factory :permasalahan_opd do
    permasalahan { "COntoh A" }
    kode_opd { "" }
    tahun { "2023" }
    status { "aktif" }
    association :isu_strategis_opd
  end
end
