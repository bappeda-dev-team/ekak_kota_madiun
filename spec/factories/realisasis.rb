# == Schema Information
#
# Table name: realisasis
#
#  id           :bigint           not null, primary key
#  jenis        :string
#  realisasi    :string
#  satuan       :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  indikator_id :bigint           not null
#  target_id    :bigint           not null
#
# Indexes
#
#  index_realisasis_on_indikator_id  (indikator_id)
#  index_realisasis_on_target_id     (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (indikator_id => indikators.id)
#  fk_rails_...  (target_id => targets.id)
#
FactoryBot.define do
  factory :realisasi do
    tahun { "MyString" }
    realisasi { "MyString" }
    satuan { "MyString" }
    jenis { "MyString" }
    target { nil }
  end
end
