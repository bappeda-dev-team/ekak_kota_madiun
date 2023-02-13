# == Schema Information
#
# Table name: strategi_opds
#
#  id                   :bigint           not null, primary key
#  strategi             :string
#  tahun                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  isu_strategis_opd_id :string
#  opd_id               :string
#  sasaran_opd_id       :string
#
FactoryBot.define do
  factory :strategi_opd do
    strategi { "MyString" }
    tahun { "MyString" }
    sasaran_opd_id { "MyString" }
    isu_strategis_opd_id { "MyString" }
    opd_id { "MyString" }
  end
end
