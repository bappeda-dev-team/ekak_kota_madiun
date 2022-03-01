# == Schema Information
#
# Table name: anggaran_sshes
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
class AnggaranSsh < ApplicationRecord
end
