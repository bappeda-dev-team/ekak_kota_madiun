# == Schema Information
#
# Table name: anggota_tims
#
#  id         :bigint           not null, primary key
#  keterangan :string
#  metadata   :jsonb
#  nama       :string
#  role       :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tim_id     :bigint           not null
#
# Indexes
#
#  index_anggota_tims_on_tim_id  (tim_id)
#
# Foreign Keys
#
#  fk_rails_...  (tim_id => tims.id)
#
FactoryBot.define do
  factory :anggota_tim do
    nama { "MyString" }
    role { "MyString" }
    keterangan { "MyString" }
    tahun { "MyString" }
    metadata { "" }
    tim { nil }
  end
end
