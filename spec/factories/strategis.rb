# == Schema Information
#
# Table name: strategis
#
#  id              :bigint           not null, primary key
#  nip_asn         :string
#  role            :string
#  strategi        :string
#  tahun           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pohon_id        :bigint
#  sasaran_id      :string
#  strategi_ref_id :string
#
# Indexes
#
#  index_strategis_on_pohon_id  (pohon_id)
#
FactoryBot.define do
  factory :strategi do
    strategi { "MyString" }
    tahun { "MyString" }
    sasaran_id { "MyString" }
    strategi_ref_id { "MyString" }
    nip_asn { "MyString" }
  end
end
