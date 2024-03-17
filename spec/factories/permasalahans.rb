# == Schema Information
#
# Table name: permasalahans
#
#  id                :bigint           not null, primary key
#  jenis             :text
#  penyebab_external :string
#  penyebab_internal :string
#  permasalahan      :text
#  tahun             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  sasaran_id        :bigint
#  usulan_id         :bigint
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
FactoryBot.define do
  factory :permasalahan do
    permasalahan { "MyText" }
    jenis { "MyText" }
    penyebab_internal { "MyString" }
    penyebab_external { "MyString" }
  end
end
