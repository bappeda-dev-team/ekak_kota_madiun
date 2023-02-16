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
#
# Indexes
#
#  index_sasaran_kota_on_id_sasaran  (id_sasaran) UNIQUE
#
class SasaranKotum < ApplicationRecord
  belongs_to :tujuan_kota, class_name: 'TujuanKota', foreign_key: 'id_tujuan', primary_key: 'kode_tujuan'
  has_many :indikator_sasarans, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_sasaran'
  has_many :sasarans_opd, class_name: 'Sasaran', foreign_key: 'sasaran_atasan_id', primary_key: 'kode_sasaran'

  def tahun_awal_akhir
    "#{tahun_awal} - #{tahun_akhir}"
  end
end
