# == Schema Information
#
# Table name: musrenbangs
#
#  id         :bigint           not null, primary key
#  tahun      :string
#  usulan     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :musrenbang do
    usulan { "Usulan Musrenbang Kelurahan Kartoharjo" }
    tahun { "2022" }
  end
end
