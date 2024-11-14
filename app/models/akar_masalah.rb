# == Schema Information
#
# Table name: akar_masalahs
#
#  id         :bigint           not null, primary key
#  jenis      :string
#  kode_opd   :string
#  masalah    :string
#  tahun      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  parent_id  :bigint
#
class AkarMasalah < ApplicationRecord
  has_many :masalahs, -> { where(jenis: 'Masalah') }, class_name: 'AkarMasalah',
                                                      primary_key: :id, foreign_key: :parent_id

  has_many :akar_masalahs, -> { where(jenis: 'AkarMasalah') }, class_name: 'AkarMasalah',
                                                               primary_key: :id, foreign_key: :parent_id
end
