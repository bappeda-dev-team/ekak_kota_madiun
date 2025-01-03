# == Schema Information
#
# Table name: realisasis
#
#  id           :bigint           not null, primary key
#  jenis        :string
#  realisasi    :string
#  satuan       :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  indikator_id :bigint           not null
#  target_id    :bigint           not null
#
# Indexes
#
#  index_realisasis_on_indikator_id  (indikator_id)
#  index_realisasis_on_target_id     (target_id)
#
# Foreign Keys
#
#  fk_rails_...  (indikator_id => indikators.id)
#  fk_rails_...  (target_id => targets.id)
#
class Realisasi < ApplicationRecord
  belongs_to :target

  def capaian
    return 0 if target.target.to_f.zero? && realisasi.to_f.zero?

    (realisasi.to_f / target.target.to_f).round(2) * 100
  end
end
