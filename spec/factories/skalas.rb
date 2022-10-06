# == Schema Information
#
# Table name: skalas
#
#  id         :bigint           not null, primary key
#  deskripsi  :string
#  keterangan :string
#  kode_skala :string
#  nilai      :string
#  tipe_nilai :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rincian_id :bigint
#
FactoryBot.define do
  factory :skala do
    jenis { "MyString" }
    pilihan { "MyString" }
    jenis_skor { "MyString" }
    skor { "MyString" }
  end
end
