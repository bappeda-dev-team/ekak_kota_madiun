# == Schema Information
#
# Table name: lembagas
#
#  id           :bigint           not null, primary key
#  nama_lembaga :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :lembaga do
    nama_lembaga { "Kota Madiun" }
    tahun { "2022" }
  end
end
