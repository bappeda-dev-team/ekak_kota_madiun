# == Schema Information
#
# Table name: pohons
#
#  id                :bigint           not null, primary key
#  keterangan        :string
#  metadata          :jsonb
#  pohon_khusus      :boolean          default(FALSE)
#  pohonable_type    :string
#  role              :string
#  status            :string
#  tahun             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  opd_id            :bigint
#  pohon_ref_id      :bigint
#  pohonable_id      :bigint
#  strategi_id       :bigint
#  strategi_pohon_id :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_pohons_on_opd_id       (opd_id)
#  index_pohons_on_pohonable    (pohonable_type,pohonable_id)
#  index_pohons_on_strategi_id  (strategi_id)
#  index_pohons_on_user_id      (user_id)
#
FactoryBot.define do
  factory :pohon do
    association :pohonable
    keterangan { "MyString" }
    # pohonable_type { "" }
    # pohonable_id { "" }
    tahun { "" }
    role { "" }
    pohon_ref_id { "" }
    status { nil }
    metadata { nil }
    opd_id { nil }
    user_id { nil }
    strategi_pohon_id { nil }
  end
end
