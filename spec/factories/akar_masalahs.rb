# == Schema Information
#
# Table name: akar_masalahs
#
#  id          :bigint           not null, primary key
#  jenis       :string
#  kode_opd    :string
#  masalah     :string
#  tahun       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  strategi_id :bigint
#
# Indexes
#
#  index_akar_masalahs_on_strategi_id  (strategi_id)
#
FactoryBot.define do
  factory :akar_masalah do
    masalah_pokok { "MyString" }
    masalah { "MyString" }
    akar_masalah { "MyString" }
    kode_opd { "MyString" }
    tahun { "MyString" }
  end
end
