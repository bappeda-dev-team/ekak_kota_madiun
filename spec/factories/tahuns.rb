# == Schema Information
#
# Table name: tahuns
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  periode_id :bigint
#
FactoryBot.define do
  factory :tahun do
    tahun { "MyString" }
    periode { "MyString" }
  end

  factory :dua_lima, class: 'Tahun' do
    tahun { "2025" }
    association :periode
  end
end
