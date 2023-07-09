# == Schema Information
#
# Table name: tujuan_kota
#
#  id          :bigint           not null, primary key
#  id_misi     :string
#  id_tujuan   :string
#  kode_tujuan :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  tujuan      :string
#  type        :string
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tujuan_kota_on_id_tujuan  (id_tujuan) UNIQUE
#
class TujuanKota < ApplicationRecord
  default_scope { order(:id) }

  scope :visis, -> { joins(%i[indikator_tujuans sasaran_kota]).where.not(visi: nil) }
  scope :misis, -> { joins(%i[indikator_tujuans sasaran_kota]).where.not(misi: nil) }
  scope :sasarans, -> { joins(:sasaran_kota) }

  has_many :indikator_tujuans, -> { order(:tahun) },
           class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_tujuan'
  accepts_nested_attributes_for :indikator_tujuans, reject_if: :all_blank, allow_destroy: true

  has_many :sasaran_kota, foreign_key: 'id_tujuan', primary_key: 'kode_tujuan'
  has_many :strategi_kota, through: :sasaran_kota

  def tahun_awal_akhir
    "#{tahun_awal} - #{tahun_akhir}"
  end

  # need fixing, indikator doubled in indikator_tujuans
  def indikators
    indikators = indikator_tujuans.group_by(&:version)
    indikators[indikators.keys.max]
  end
end
