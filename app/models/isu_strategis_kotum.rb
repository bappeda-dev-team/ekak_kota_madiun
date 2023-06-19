# == Schema Information
#
# Table name: isu_strategis_kota
#
#  id            :bigint           not null, primary key
#  isu_strategis :string           not null
#  keterangan    :string
#  kode          :string           not null
#  tahun         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  lembaga_id    :bigint           default(1)
#
class IsuStrategisKotum < ApplicationRecord
  default_scope { order(:id) }
  has_many :strategi_kotums, foreign_key: 'isu_strategis_kota_id', primary_key: 'id'

  has_many :opds, through: :strategi_kotums

  def to_s
    self.class.name.pluralize.underscore.titleize
  end

  def strategi_kota_tahun(tahun)
    strategi_kotums.where('tahun ILIKE ?', "%#{tahun}%")
  end

  def strategis(opd_id)
    strategi_kotums.includes(:pohons).where(pohons: { opd_id: opd_id })
  end

  def strategis_opd(opd_id)
    strategis(opd_id)
  end

  def clone_mapper
    IsuStrategisKotum.where('kode ILIKE ?', "%#{kode}%")
  end
end
