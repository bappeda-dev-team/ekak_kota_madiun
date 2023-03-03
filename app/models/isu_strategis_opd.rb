# == Schema Information
#
# Table name: isu_strategis_opds
#
#  id            :bigint           not null, primary key
#  isu_strategis :string           not null
#  kode          :string           not null
#  kode_opd      :string           not null
#  tahun         :string           not null
#  tujuan        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class IsuStrategisOpd < ApplicationRecord
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  has_many :pohons, as: :pohonable, dependent: :destroy

  def strategi
    isu_strategis
  end

  def nama_pemilik
    opd&.nama_opd
  end
end
