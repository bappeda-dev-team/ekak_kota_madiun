# == Schema Information
#
# Table name: latar_belakangs
#
#  id            :bigint           not null, primary key
#  dasar_hukum   :text
#  gambaran_umum :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  sasaran_id    :bigint
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class LatarBelakang < ApplicationRecord
  # has_rich_text :dasar_hukum
  # has_rich_text :gambaran_umum
  # TODO: remove dasar_hukum later, or connect it
  belongs_to :sasaran, optional: true
  validates :gambaran_umum, presence: true
end
