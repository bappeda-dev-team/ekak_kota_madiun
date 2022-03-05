# == Schema Information
#
# Table name: latar_belakangs
#
#  id            :bigint           not null, primary key
#  dasar_hukum   :text
#  gambaran_umum :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class LatarBelakang < ApplicationRecord
  has_rich_text :dasar_hukum
  has_rich_text :gambaran_umum

  validates :dasar_hukum, presence: true
end
