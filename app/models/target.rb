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
  has_one :realisasi, dependent: :destroy

  belongs_to :indikator
  belongs_to :opd, optional: true

  scope :by_periode, lambda { |tahun_awal, tahun_akhir|
                       where("tahun::integer BETWEEN ?::integer AND ?::integer", tahun_awal, tahun_akhir)
                     }
  def to_s
    target
  end

  def target_satuan
    "#{target} #{satuan}"
  end

  def capaian
    return 0 if target.to_f.zero? && realisasi&.realisasi.to_f.zero?

    (realisasi&.realisasi.to_f / target).round(2) * 100
  end
end
