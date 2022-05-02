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
module Search
  class AllAnggaran < ApplicationRecord
    belongs_to :searchable, polymorphic: true
  end
end
