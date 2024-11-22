# == Schema Information
#
# Table name: crosscuttings
#
#  id                :bigint           not null, primary key
#  opd_pelaksana     :string
#  tipe_crosscutting :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  strategi_id       :bigint           not null
#
# Indexes
#
#  index_crosscuttings_on_strategi_id  (strategi_id)
#
# Foreign Keys
#
#  fk_rails_...  (strategi_id => strategis.id)
#
FactoryBot.define do
  factory :crosscutting do
    tipe_crosscutting { "MyString" }
    strategi { nil }
  end
end
