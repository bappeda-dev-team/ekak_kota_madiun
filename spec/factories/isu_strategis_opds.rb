# == Schema Information
#
# Table name: isu_strategis_opds
#
#  id                 :bigint           not null, primary key
#  isu_strategis      :string           not null
#  keterangan         :string
#  kode               :string           not null
#  kode_bidang_urusan :string
#  kode_opd           :string           not null
#  tahun              :string           not null
#  tujuan             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
FactoryBot.define do
  factory :isu_strategis_opd do
    kode { "MyString" }
    isu_strategis { "MyString" }
    tahun { "MyString" }
    kode_opd { "MyString" }
    tujuan { "MyString" }
  end
end
