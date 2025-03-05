# == Schema Information
#
# Table name: tagging_anggarans
#
#  id          :bigint           not null, primary key
#  tagging     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint           not null
#
# Indexes
#
#  index_tagging_anggarans_on_anggaran_id  (anggaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (anggaran_id => anggarans.id)
#
FactoryBot.define do
  factory :tagging_anggaran do
    tagging { "MyString" }
    anggaran_id { nil }
  end
end
