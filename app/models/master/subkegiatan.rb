# == Schema Information
#
# Table name: master_subkegiatans
#
#  id                   :bigint           not null, primary key
#  id_bidang_urusan     :string
#  id_kegiatan          :string
#  id_program           :string
#  id_sub_kegiatan_sipd :string
#  id_unik_sipd         :string           not null
#  id_urusan            :string
#  kode_sub_kegiatan    :string
#  nama_sub_kegiatan    :string           default("-")
#  no_sub_kegiatan      :string
#  tahun                :string           default("2022")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_master_subkegiatans_on_id_unik_sipd  (id_unik_sipd) UNIQUE
#
class Master::Subkegiatan < ApplicationRecord
end
