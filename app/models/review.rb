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
class Review < ApplicationRecord
  validates :reviewable_id, presence: true
  validates :reviewable_type, presence: true
  validates :reviewer_id, presence: true

  belongs_to :user, primary_key: :id, foreign_key: :reviewer_id
end
