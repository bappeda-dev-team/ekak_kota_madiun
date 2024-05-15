# == Schema Information
#
# Table name: asets
#
#  id            :bigint           not null, primary key
#  jumlah        :integer
#  keterangan    :string
#  kode_unik_opd :string
#  kondisi       :text             default([]), is an Array
#  nama_aset     :string
#  satuan        :string
#  status_aset   :jsonb
#  tahun_akhir   :integer
#  tahun_aset    :string           is an Array
#  tahun_awal    :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :aset do
    nama_aset { "MyString" }
    jumlah { 1 }
    satuan { "MyString" }
    kondisi { "MyText" }
    tahun_awal { "MyString" }
    tahun_akhir { "MyString" }
    keterangan { "MyString" }
  end
end
