# == Schema Information
#
# Table name: indikators
#
#  id        :bigint           not null, primary key
#  indikator :string
#  jenis     :string
#  kode      :string
#  satuan    :string
#  sub_jenis :string
#  tahun     :string
#  target    :string
#
FactoryBot.define do
  factory :indikator do
    indikator { "MyString" }
    target { "MyString" }
    satuan { "MyString" }
    tahun { "MyString" }
    jenis { "MyString" }
    kode { "MyString" }
  end
end
