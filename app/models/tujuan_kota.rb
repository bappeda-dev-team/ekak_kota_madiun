# == Schema Information
#
# Table name: tujuan_kota
#
#  id          :bigint           not null, primary key
#  id_misi     :string
#  id_tujuan   :string
#  kode_tujuan :string
#  misi        :string
#  tahun_akhir :string
#  tahun_awal  :string
#  tujuan      :string
#  type        :string
#  visi        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tujuan_kota_on_id_tujuan  (id_tujuan) UNIQUE
#
class TujuanKota < ApplicationRecord
  has_many :indikator_tujuans, class_name: 'Indikator', foreign_key: 'kode', primary_key: 'id_tujuan'
end
