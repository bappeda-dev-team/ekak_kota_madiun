# == Schema Information
#
# Table name: mandatoris
#
#  id                :bigint           not null, primary key
#  peraturan_terkait :string
#  usulan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :mandatori do
    usulan { "MyString" }
    peraturan_terkait { "MyString" }
  end
end
