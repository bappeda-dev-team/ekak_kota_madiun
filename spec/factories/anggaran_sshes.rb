# == Schema Information
#
# Table name: anggaran_sshes
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
  factory :anggaran_ssh do
    kode_kelompok_barang { "MyString" }
    uraian_kelompok_barang { "MyString" }
    kode_barang { "MyString" }
    uraian_barang { "MyString" }
    spesifikasi { "MyString" }
    satuan { "MyString" }
    harga_satuan { "" }
  end
end
