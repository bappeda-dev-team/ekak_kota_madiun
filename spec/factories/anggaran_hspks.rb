# == Schema Information
#
# Table name: anggaran_hspks
#
#  id                     :bigint           not null, primary key
#  harga_satuan           :bigint
#  kode_barang            :string
#  kode_kelompok_barang   :string
#  satuan                 :string
#  spesifikasi            :string
#  uraian_barang          :string
#  uraian_kelompok_barang :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :anggaran_hspk do
    kode_kelompok_barang { "MyString" }
    uraian_kelompok_barang { "MyString" }
    kode_barang { "MyString" }
    uraian_barang { "MyString" }
    spesifikasi { "MyString" }
    satuan { "MyString" }
    harga_satuan { "" }
  end
end
