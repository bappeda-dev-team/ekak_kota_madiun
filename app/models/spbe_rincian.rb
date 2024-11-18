# == Schema Information
#
# Table name: spbe_rincians
#
#  id                     :bigint           not null, primary key
#  aspek_spbe             :string
#  detail_kebutuhan       :string
#  detail_sasaran_kinerja :string
#  domain_spbe            :string
#  id_rencana             :string
#  internal_external      :string
#  kebutuhan_spbe         :string
#  keterangan             :string
#  kode_opd               :string
#  kode_program           :string
#  metadata               :jsonb
#  subdomain_spbe         :string
#  tahun_akhir            :string
#  tahun_akhir_pemohon    :string
#  tahun_awal             :string
#  tahun_awal_pemohon     :string
#  tahun_pelaksanaan      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  spbe_id                :bigint
#  strategi_ref_id        :string
#
class SpbeRincian < ApplicationRecord
  validates_presence_of :domain_spbe, :detail_kebutuhan

  belongs_to :spbe, inverse_of: :spbe_rincians

  belongs_to :sasaran, -> { order "nip_asn ASC" }, primary_key: :id, foreign_key: :id_rencana, optional: true

  has_one :opd, primary_key: :kode_opd, foreign_key: :kode_unik_opd

  store_accessor :metadata, :status_kebutuhan_spbe, :keterangan_kebutuhan_spbe, :kondisi_sekarang

  def sasaran_kinerja
    sasaran.present? ? sasaran : 'Belum diisi'
  end

  def tahun_spbe
    "#{tahun_awal}-#{tahun_akhir}"
  end

  def tahun_pemohon_spbe
    if tahun_awal_pemohon.present? && tahun_akhir_pemohon.present?
      "#{tahun_awal_pemohon}-#{tahun_akhir_pemohon}"
    else
      ''
    end
  end

  def diterima?
    status_kebutuhan_spbe == 'Terima' || status_kebutuhan_spbe.blank?
  end
end
