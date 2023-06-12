# == Schema Information
#
# Table name: spbe_rincians
#
#  id                     :bigint           not null, primary key
#  detail_kebutuhan       :string
#  detail_sasaran_kinerja :string
#  id_rencana             :string
#  internal_external      :string
#  kebutuhan_spbe         :string
#  keterangan             :string
#  kode_opd               :string
#  kode_program           :string
#  tahun_akhir            :string
#  tahun_awal             :string
#  tahun_pelaksanaan      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  spbe_id                :bigint
#  strategi_ref_id        :string
#
class SpbeRincian < ApplicationRecord
  belongs_to :spbe, inverse_of: :spbe_rincians

  belongs_to :sasaran, -> { order "nip_asn ASC" }, primary_key: :id, foreign_key: :id_rencana

  has_one :opd, primary_key: :kode_opd, foreign_key: :kode_unik_opd
end
