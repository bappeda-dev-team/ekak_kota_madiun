# == Schema Information
#
# Table name: kamus_usulans
#
#  id            :bigint           not null, primary key
#  bidang_urusan :string
#  id_kamus      :bigint           not null
#  id_program    :bigint
#  id_unit       :bigint
#  usulan        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_kamus_usulans_on_id_kamus  (id_kamus) UNIQUE
#
class KamusUsulan < ApplicationRecord
  validates :id_kamus, presence: true
end
