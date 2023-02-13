# == Schema Information
#
# Table name: usulan_perangkat_daerahs
#
#  id                    :bigint           not null, primary key
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :integer
#  perangkat_daerah_id   :integer
#  strategi_kota_id      :integer
#
FactoryBot.define do
  factory :usulan_perangkat_daerah do
    perangkat_daerah_id { "MyString" }
    strategi_kota_id { "MyString" }
    isu_strategis_kota_id { "MyString" }
  end
end
