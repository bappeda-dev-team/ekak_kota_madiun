# == Schema Information
#
# Table name: file_skp_opds
#
#  id            :bigint           not null, primary key
#  kode_unik_opd :string
#  tahun         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :file_skp_opd do
    kode_unik_opd { "MyString" }
    tahun { "MyString" }
    file_skp { nil }
  end
end
