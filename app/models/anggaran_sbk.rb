# == Schema Information
#
# Table name: anggaran_sbks
#
#  id                     :bigint           not null, primary key
#  harga_satuan           :bigint
#  id_standar_harga       :string
#  kode_barang            :string
#  kode_kelompok_barang   :string
#  satuan                 :string
#  spesifikasi            :string
#  tahun                  :string
#  uraian_barang          :string
#  uraian_kelompok_barang :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  opd_id                 :bigint
#
class AnggaranSbk < ApplicationRecord
  validates :kode_barang, presence: true
  validates :kode_kelompok_barang, presence: true
end
