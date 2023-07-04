# == Schema Information
#
# Table name: periodes
#
#  id          :bigint           not null, primary key
#  tahun_akhir :string
#  tahun_awal  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :periode do
    tahun_awal { "MyString" }
    tahun_akhir { "MyString" }
  end
end
