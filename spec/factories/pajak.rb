# == Schema Information
#
# Table name: pajaks
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  tipe       :string
#  potongan   :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :pajak do
    tipe { 'Pajak Penghasilan' }
    tahun { '2022' }
    potongan { 0.1 }
  end
end
