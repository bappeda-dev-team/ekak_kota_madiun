# == Schema Information
#
# Table name: anggaran_sbus
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
#
require 'rails_helper'

RSpec.describe AnggaranSbu, type: :model do
  context 'validateion' do
    it { should validate_presence_of(:kode_barang) }
    it { should validate_presence_of(:kode_kelompok_barang) }
  end
end
