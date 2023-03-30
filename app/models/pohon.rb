# == Schema Information
#
# Table name: pohons
#
#  id             :bigint           not null, primary key
#  keterangan     :string
#  pohonable_type :string
#  role           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  opd_id         :bigint
#  pohonable_id   :bigint
#  strategi_id    :bigint
#  user_id        :bigint
#
# Indexes
#
#  index_pohons_on_opd_id       (opd_id)
#  index_pohons_on_pohonable    (pohonable_type,pohonable_id)
#  index_pohons_on_strategi_id  (strategi_id)
#  index_pohons_on_user_id      (user_id)
#
class Pohon < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :pohonable, polymorphic: true
  belongs_to :opd, optional: true
  belongs_to :user, optional: true
  has_many :strategis, -> { where(strategis: { role: "eselon_2" }) }

  scope :pohon_opd, -> { where(pohonable_type: "IsuStrategisOpd") }
  scope :pohon_kota, -> { where(pohonable_type: "StrategiKotum") }

  def strategi_kota_isu_strategis
    "Isu Strategis: #{keterangan} - Strategi Kota: #{pohonable.strategi}"
  end

  def strategi_kepala_by_opd
    strategis.pluck(:strategi).map.with_index(1) do |ss, no|
      "#{no}. #{ss}\n"
    end
  end
end
