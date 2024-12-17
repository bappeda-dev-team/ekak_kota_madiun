# == Schema Information
#
# Table name: akar_masalahs
#
#  id          :bigint           not null, primary key
#  jenis       :string
#  kode_opd    :string
#  masalah     :string
#  tahun       :string
#  terpilih    :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  strategi_id :bigint
#
# Indexes
#
#  index_akar_masalahs_on_strategi_id  (strategi_id)
#
class AkarMasalah < ApplicationRecord
  belongs_to :strategi
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd', optional: true

  def to_s
    masalah
  end

  def terpilih?
    terpilih || false
  end
end
