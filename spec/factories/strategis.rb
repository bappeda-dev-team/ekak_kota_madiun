# == Schema Information
#
# Table name: strategis
#
#  id              :bigint           not null, primary key
#  nip_asn         :string
#  strategi        :string
#  tahun           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sasaran_id      :string
#  strategi_ref_id :string
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
