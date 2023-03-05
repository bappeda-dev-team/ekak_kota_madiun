# == Schema Information
#
# Table name: isu_strategis_kota
#
#  id            :bigint           not null, primary key
#  isu_strategis :string           not null
#  kode          :string           not null
#  tahun         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class IsuStrategisKotum < ApplicationRecord
  default_scope { order(:id) }
  has_many :strategi_kotums, foreign_key: 'isu_strategis_kota_id', primary_key: 'id'

  has_many :opds, through: :strategi_kotums

  def strategis
    strategi_kotums
  end
end
