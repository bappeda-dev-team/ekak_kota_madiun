# == Schema Information
#
# Table name: anggaran_sbks
#
#  id                     :bigint           not null, primary key
#  harga_satuan           :bigint
#  id_standar_harga       :string
#  kode_barang            :string
#  kode_kelompok_barang   :string
#  satuan                 :string
#  spesifikasi            :string
#  tahun                  :string
#  uraian_barang          :string
#  uraian_kelompok_barang :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  opd_id                 :bigint
#
FactoryBot.define do
  factory :anggaran_sbk do
    harga_satuan { "" }
    id_standar_harga { "MyString" }
    kode_barang { "MyString" }
    kode_kelompok_barang { "MyString" }
    satuan { "MyString" }
    spesifikasi { "MyString" }
    tahun { "MyString" }
    uraian_barang { "MyString" }
    uraian_kelompok_barang { "MyString" }
    opd_id { "" }
  end
end
