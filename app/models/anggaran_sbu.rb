# == Schema Information
#
# Table name: anggaran_sbus
#
#  id                     :bigint           not null, primary key
#  harga_satuan           :bigint
#  kode_barang            :string
#  kode_kelompok_barang   :string
#  satuan                 :string
#  spesifikasi            :string
#  uraian_barang          :string
#  uraian_kelompok_barang :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class AnggaranSbu < ApplicationRecord
  validates :kode_barang, presence: true
  validates :kode_kelompok_barang, presence: true
end
