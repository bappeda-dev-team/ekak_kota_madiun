# == Schema Information
#
# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
FactoryBot.define do
  factory :strategi_kotum do
    strategi { "Strategi kota test" }
    tahun { "2023" }
    sasaran_kota_id { "" }
    isu_strategis_kota_id { "1" }
  end
end
