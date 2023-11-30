# == Schema Information
#
# Table name: tematiks
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  level          :integer          default(1)
#  tahun          :string
#  tema           :string
#  type           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tematik_ref_id :bigint
#
FactoryBot.define do
  factory :tematik do
    tema { "MyString" }
    keterangan { "MyString" }
    tematik_ref_id { "" }
    type { "" }
  end
end
