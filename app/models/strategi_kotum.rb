# == Schema Information
#
# Table name: strategi_kota
#
#  id                    :bigint           not null, primary key
#  keterangan            :string
#  strategi              :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  isu_strategis_kota_id :string
#  sasaran_kota_id       :string
#
class StrategiKotum < ApplicationRecord
  default_scope { order(:id) }
  belongs_to :isu_strategis_kotum, foreign_key: 'isu_strategis_kota_id', primary_key: 'id', optional: true
  belongs_to :sasaran_kotum, foreign_key: 'sasaran_kota_id', primary_key: 'kode_sasaran', optional: true

  has_many :usulans, as: :usulanable, dependent: :destroy
  has_many :pohons, as: :pohonable, dependent: :destroy

  has_many :strategis, -> { where(type: nil) }, through: :pohons
  has_many :strategi_pohons, through: :pohons
  has_many :opds, through: :pohons
  has_many :komentars, -> { where(kode_opd: 'kota_madiun') }, primary_key: :id, foreign_key: :item

  def to_s
    self.class.name.pluralize.underscore.titleize
  end

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

  def strategis_opd(opd_id)
    strategis.where(opd_id: opd_id).compact_blank
  end

  def strategis_opd_not_cascade(opd_id)
    strategi_pohons.where(opd_id: opd_id.to_s).compact_blank
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

  def indikators_tahun(tahun)
    sasaran_kotum.indikator_sasarans.where('tahun ILIKE ?', "%#{tahun}%")
  end

  def indikator(tahun)
    indikators_tahun(tahun).first.indikator
  end

  def target(tahun)
    indikators_tahun(tahun).first.target
  end

  def satuan(tahun)
    indikators_tahun(tahun).first.satuan
  end
end
