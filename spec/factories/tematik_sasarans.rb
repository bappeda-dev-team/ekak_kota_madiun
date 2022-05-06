# == Schema Information
#
# Table name: tematik_sasarans
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sasaran_id             :bigint
#  subkegiatan_tematik_id :bigint
#
# Indexes
#
#  index_tematik_sasarans_on_sasaran_id              (sasaran_id)
#  index_tematik_sasarans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#
FactoryBot.define do
  factory :tematik_sasaran do
    sasaran { nil }
    subkegiatan_tematik { nil }
  end
end
