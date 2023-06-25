# == Schema Information
#
# Table name: kebutuhans
#
#  id         :bigint           not null, primary key
#  kebutuhan  :string
#  keterangan :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :kebutuhan do
    kebutuhan { "MyString" }
    tahun { "MyString" }
    keterangan { "MyString" }
  end
end
