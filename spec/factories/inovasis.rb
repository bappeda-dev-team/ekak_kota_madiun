# == Schema Information
#
# Table name: inovasis
#
#  id         :bigint           not null, primary key
#  manfaat    :string
#  usulan     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :inovasi do
    usulan { "MyString" }
    manfaat { "MyString" }
  end
end
