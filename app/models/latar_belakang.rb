# == Schema Information
#
# Table name: latar_belakangs
#
#  id                   :bigint           not null, primary key
#  dasar_hukum          :text
#  gambaran_umum        :text
#  id_indikator_sasaran :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  sasaran_id           :bigint
#
# Indexes
#
#  index_latar_belakangs_on_id_indikator_sasaran  (id_indikator_sasaran) UNIQUE
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
