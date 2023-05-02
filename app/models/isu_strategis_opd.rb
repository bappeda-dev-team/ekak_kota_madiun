# == Schema Information
#
# Table name: isu_strategis_opds
#
#  id            :bigint           not null, primary key
#  isu_strategis :string           not null
#  keterangan    :string
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

  def isu
    self
  end

  def startegis
    pohons
  end

  def nama_isu
    isu.isu_strategis
  end

  def strategis
    pohons
  end

  def sasaran_kotum_id; end

  def sasaran_kotum_sasaran; end

  def strategis_opd(_opd_id)
    pohons
  end
end
