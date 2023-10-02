# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  keterangan      :string
#  metadata        :jsonb
#  reviewable_type :string
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  reviewable_id   :bigint
#  reviewer_id     :bigint
#
FactoryBot.define do
  factory :review do
    keterangan { "MyString" }
    reviewable_type { "MyString" }
    reviewable_id { "" }
    reviewer_id { "MyString" }
    status { "MyString" }
    metadata { "" }
  end
end
