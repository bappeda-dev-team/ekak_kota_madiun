# == Schema Information
#
# Table name: sasaran_kota
#
#  id           :bigint           not null, primary key
#  id_misi      :string
#  id_sasaran   :string
#  id_tujuan    :string
#  kode_sasaran :string
#  misi         :string
#  sasaran      :string
#  tahun_akhir  :string
#  tahun_awal   :string
#  tujuan       :string
#  visi         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  tematik_id   :bigint
#
# Indexes
#
#  index_sasaran_kota_on_id_sasaran  (id_sasaran) UNIQUE
#  index_sasaran_kota_on_tematik_id  (tematik_id)
#
class SasaranKotum < ApplicationRecord
  default_scope { order(:id) }

  belongs_to :tujuan_kota, class_name: 'TujuanKota', foreign_key: 'id_tujuan', primary_key: 'kode_tujuan'
  belongs_to :tematik

  # has_many :indikator_sasarans, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_sasaran'
  # accepts_nested_attributes_for :indikator_sasarans, reject_if: :all_blank, allow_destroy: true

  # has_many :sasarans_opd, class_name: 'Sasaran', foreign_key: 'sasaran_atasan_id', primary_key: 'kode_sasaran'
  has_one :strategi_kotum, foreign_key: 'sasaran_kota_id', primary_key: 'kode_sasaran'

  def indikators
    tematik.indikators
  end

  def indikator_sasarans
    indikators
  end

  def to_s
    sasaran
  end

  def tahun_awal_akhir
    "#{tahun_awal} - #{tahun_akhir}"
  end
end
