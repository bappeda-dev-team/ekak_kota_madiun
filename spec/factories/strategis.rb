# == Schema Information
#
# Table name: strategis
#
#  id                    :bigint           not null, primary key
#  linked_with           :bigint
#  metadata              :jsonb
#  nip_asn               :string
#  nip_asn_sebelumnya    :string
#  role                  :string
#  strategi              :string
#  strategi_cascade_link :bigint
#  tahun                 :string
#  type                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  opd_id                :string
#  pohon_id              :bigint
#  sasaran_id            :string
#  strategi_ref_id       :string
#  tujuan_id             :bigint
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
FactoryBot.define do
  factory :strategi do
    strategi { "Contoh Strategi" }
    tahun { "2024" }
    role { "" }
    nip_asn { "" }
    association :opd
  end
end
