# == Schema Information
#
# Table name: strategi_opds
#
#  id                   :bigint           not null, primary key
#  strategi             :string
#  tahun                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  isu_strategis_opd_id :string
#  opd_id               :string
#  sasaran_opd_id       :string
#
class StrategiOpd < ApplicationRecord
  belongs_to :opd, foreign_key: 'opd_id', primary_key: 'kode_opd'

  def nama_pemilik
    opd&.nama_opd
  end
end
