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
require 'rails_helper'

RSpec.describe AnggaranSsh, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
