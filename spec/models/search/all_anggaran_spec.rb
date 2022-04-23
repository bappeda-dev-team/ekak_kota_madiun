# == Schema Information
#
# Table name: search_all_anggarans
#
#  harga_satuan    :bigint
#  kode_barang     :string
#  satuan          :string
#  searchable_type :text
#  spesifikasi     :string
#  uraian_barang   :string
#  searchable_id   :bigint
#
require 'rails_helper'

RSpec.describe Search::AllAnggaran, type: :model do
  context 'validation' do
    it { is_expected.to belong_to(:searchable) }
  end
end
