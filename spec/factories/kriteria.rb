# == Schema Information
#
# Table name: kriteria
#
#  id            :bigint           not null, primary key
#  keterangan    :string
#  kriteria      :string
#  poin          :integer
#  poin_max      :integer
#  poin_min      :integer
#  tipe_kriteria :string
#  type          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  kriteria_id   :bigint
#
FactoryBot.define do
  factory :kriterium do
    kriteria { "MyString" }
    poin { 1 }
    poin_max { 1 }
    poin_min { 1 }
    keterangan { "MyString" }
    type { "" }
  end
end
