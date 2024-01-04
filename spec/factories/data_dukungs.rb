# == Schema Information
#
# Table name: data_dukungs
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  nama_data  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :data_dukung do
    nama_data { "Test Data" }
    keterangan { "test data" }
  end
end
