# == Schema Information
#
# Table name: sumber_danas
#
#  id               :bigint           not null, primary key
#  kode_sumber_dana :string
#  sumber_dana      :string
#  tahun            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :sumber_dana do
    kode_sumber_dana { "dana_transfer" }
    sumber_dana { "Transfer" }
    tahun { "2022" }
  end
end
