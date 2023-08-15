# == Schema Information
#
# Table name: targets
#
#  id           :bigint           not null, primary key
#  jenis        :string
#  satuan       :string
#  tahun        :string
#  target       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  indikator_id :bigint
#  opd_id       :bigint
#
# Indexes
#
#  index_targets_on_indikator_id  (indikator_id)
#  index_targets_on_opd_id        (opd_id)
#
class Target < ApplicationRecord
  belongs_to :indikator
  belongs_to :opd, optional: true

  def to_s
    target
  end
end
