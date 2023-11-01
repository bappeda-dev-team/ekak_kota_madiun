# == Schema Information
#
# Table name: status_tombols
#
#  id          :bigint           not null, primary key
#  disabled    :boolean
#  keterangan  :string
#  kode_opd    :string
#  kode_tombol :string
#  tahun       :string
#  tombol      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :status_tombol do
    status { false }
    tombol { "MyString" }
    keterangan { "MyString" }
    kode_tombol { "MyString" }
  end
end
