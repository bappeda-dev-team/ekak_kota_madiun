# == Schema Information
#
# Table name: akar_masalahs
#
#  id          :bigint           not null, primary key
#  jenis       :string
#  kode_opd    :string
#  masalah     :string
#  tahun       :string
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

  def to_s
    masalah
  end
end
