# == Schema Information
#
# Table name: tujuan_kota
#
#  id          :bigint           not null, primary key
#  id_misi     :string
#  id_tujuan   :string
#  kode_tujuan :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  tujuan      :string
#  type        :string
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tujuan_kota_on_id_tujuan  (id_tujuan) UNIQUE
#
FactoryBot.define do
  factory :tujuan_kotum do
    id_misi { "MyString" }
    tahun_awal { "MyString" }
    tahun_akhir { "MyString" }
    id_tujuan { "MyString" }
    visi { "MyString" }
    misi { "MyString" }
    tujuan { "MyString" }
  end
end
