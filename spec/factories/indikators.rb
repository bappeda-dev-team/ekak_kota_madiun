# == Schema Information
#
# Table name: indikators
#
#  id                   :bigint           not null, primary key
#  definisi_operational :jsonb
#  indikator            :string
#  jenis                :string
#  keterangan           :string
#  kode                 :string
#  kode_indikator       :string
#  kode_opd             :string
#  kotak                :integer          default(0), not null
#  pagu                 :string           default("0")
#  realisasi            :string
#  realisasi_pagu       :string
#  satuan               :string
#  sub_jenis            :string
#  tahun                :string
#  target               :string
#  version              :integer          default(0), not null
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
