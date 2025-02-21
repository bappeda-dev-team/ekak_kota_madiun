# == Schema Information
#
# Table name: kolabs
#
#  id             :bigint           not null, primary key
#  jenis          :string
#  keterangan     :string
#  kode_unik_opd  :string
#  kolabable_type :string
#  status         :string
#  tahun          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  kolabable_id   :bigint
#
FactoryBot.define do
  factory :kolab do
    kolabable_type { "MyString" }
    kolabable_id { "" }
    jenis { "MyString" }
    kode_unik_opd { "MyString" }
    tahun { "MyString" }
    status { "MyString" }
    keterangan { "MyString" }
  end
end
