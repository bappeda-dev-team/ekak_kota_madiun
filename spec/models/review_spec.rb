# == Schema Information
#
# Table name: reviews
#
#  id              :bigint           not null, primary key
#  keterangan      :string
#  kriteria_type   :string
#  metadata        :jsonb
#  reviewable_type :string
#  skor            :integer
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  kriteria_id     :bigint
#  reviewable_id   :bigint
#  reviewer_id     :bigint
#
require 'rails_helper'

RSpec.describe Review, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
