# == Schema Information
#
# Table name: subkegiatan_tematiks
#
#  id           :bigint           not null, primary key
#  kode_tematik :string
#  nama_tematik :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :subkegiatan_tematik do
    kode_tematik { 'smart-city' }
    nama_tematik { 'SMART CITY' }
    tahun { '2022' }
  end
end
