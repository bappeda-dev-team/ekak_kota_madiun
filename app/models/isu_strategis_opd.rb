# == Schema Information
#
# Table name: isu_strategis_opds
#
#  id                 :bigint           not null, primary key
#  bidang_urusan      :string
#  isu_strategis      :string           not null
#  keterangan         :string
#  kode               :string
#  kode_bidang_urusan :string
#  kode_opd           :string           not null
#  tahun              :string           not null
#  tujuan             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class IsuStrategisOpd < ApplicationRecord
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_unik_opd'
  has_many :pohons, as: :pohonable, dependent: :destroy
  has_many :komentars, -> { where(jenis: 'IsuOpd') }, primary_key: :id, foreign_key: :item
  has_many :permasalahan_opds

  accepts_nested_attributes_for :permasalahan_opds, reject_if: :all_blank, allow_destroy: true

  def to_s
    isu_strategis
  end

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
