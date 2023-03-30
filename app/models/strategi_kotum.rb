# == Schema Information
#
# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
class StrategiKotum < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :isu_strategis_kotum, foreign_key: 'isu_strategis_kota_id', primary_key: 'id'
  belongs_to :sasaran_kotum, foreign_key: 'sasaran_kota_id', primary_key: 'kode_sasaran', optional: true

  has_many :usulans, as: :usulanable, dependent: :destroy
  has_many :pohons, as: :pohonable, dependent: :destroy

  has_many :strategis, through: :pohons
  has_many :opds, through: :pohons

  def nama_pemilik
    "Kota Madiun"
  end

  def isu
    isu_strategis_kotum
  end

  def nama_isu
    isu.isu_strategis
  end

  def strategi_opd(opd_id)
    pohons.where(opd_id: opd_id)
  end

  def sasaran_kotum_id
    sasaran_kotum.id
  end

  def sasaran_kotum_sasaran
    sasaran_kotum.sasaran
  end

  def indikators
    sasaran_kotum.indikator_sasarans
  end

  def indikator_tahun(tahun)
    sasaran_kotum.indikator_sasarans.where(tahun: tahun).order(id: :desc).first
  end
end
