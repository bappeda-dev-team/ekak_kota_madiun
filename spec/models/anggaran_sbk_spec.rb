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
require 'rails_helper'

RSpec.describe AnggaranSbk, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
