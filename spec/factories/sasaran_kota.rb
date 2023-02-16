# == Schema Information
#
# Table name: sasaran_kota
#
#  id           :bigint           not null, primary key
#  id_misi      :string
#  id_sasaran   :string
#  id_tujuan    :string
#  kode_sasaran :string
#  misi         :string
#  sasaran      :string
#  tahun_akhir  :string
#  tahun_awal   :string
#  tujuan       :string
#  visi         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_sasaran_kota_on_id_sasaran  (id_sasaran) UNIQUE
#
FactoryBot.define do
  factory :sasaran_kotum do
    id_misi { "id_misi" }
    id_tujuan { "id_tujuan" }
    id_sasaran { "id_sasaran" }
    tahun_awal { "2020" }
    tahun_akhir { "2024" }
    visi { "visi test" }
    misi { "misi test" }
    tujuan { "tujuan test" }
    sasaran { "sasaran test" }
  end
end
