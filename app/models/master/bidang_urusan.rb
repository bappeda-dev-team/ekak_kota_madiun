# == Schema Information
#
# Table name: master_bidang_urusans
#
#  id                    :bigint           not null, primary key
#  id_bidang_urusan_sipd :string
#  id_unik_sipd          :string           not null
#  id_urusan             :string
#  kode_bidang_urusan    :string
#  nama_bidang_urusan    :string
#  tahun                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_master_bidang_urusans_on_id_unik_sipd  (id_unik_sipd) UNIQUE
#
class Master::BidangUrusan < ApplicationRecord
  has_many :tujuan_opds
  def nama_urusan
    Master::Urusan.find_by(id_urusan_sipd: id_urusan).nama_urusan
  end

  def kode_nama_bidang
    "#{kode_bidang_urusan} - #{nama_bidang_urusan}"
  end
end
