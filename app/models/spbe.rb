# == Schema Information
#
# Table name: spbes
#
#  id                  :bigint           not null, primary key
#  jenis_pelayanan     :string
#  kode_opd            :string
#  kode_program        :string
#  nama_aplikasi       :string
#  output_aplikasi     :string
#  output_cetak        :string
#  output_data         :string
#  output_informasi    :string
#  pemilik_aplikasi    :string
#  terintegrasi_dengan :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  strategi_id         :bigint
#  strategi_ref_id     :string
#
class Spbe < ApplicationRecord
  validates_presence_of :nama_aplikasi, :program_kegiatan_id

  belongs_to :program_kegiatan, -> { order "kode_program" }

  # for some reason strategi_ref_id is actually Sasaran
  has_one :sasaran, -> { order "nip_asn ASC" }, primary_key: :strategi_ref_id, foreign_key: :id
  belongs_to :strategi
  has_one :opd, primary_key: :kode_opd, foreign_key: :kode_unik_opd

  has_many :spbe_rincians, -> { order "id ASC" }, inverse_of: :spbe
  accepts_nested_attributes_for :spbe_rincians, reject_if: :all_blank, allow_destroy: true

  scope :by_opd, lambda { |kode_opd|
    includes(:spbe_rincians)
      .where(kode_opd: kode_opd)
  }
  scope :by_opd_tujuan, lambda { |kode_opd|
    includes(:spbe_rincians)
      .where(spbe_rincians: { kode_opd: kode_opd })
      .where.not(kode_opd: kode_opd)
  }

  scope :all_in_opd_by_domain, lambda { |kode_opd, domain: 'all'|
    if domain.present? && domain != 'all'
      internal = by_opd(kode_opd).where(spbe_rincians: { domain_spbe: domain })
      external = by_opd_tujuan(kode_opd).where(spbe_rincians: { domain_spbe: domain })
    else
      internal = by_opd(kode_opd).where.not(spbe_rincians: { domain_spbe: [nil, ''] })
      external = by_opd_tujuan(kode_opd).where.not(spbe_rincians: { domain_spbe: [nil, ''] })
    end
    internal + external
  }

  def nama_program
    program_kegiatan.nama_program
  end

  def nama_urusan
    program_kegiatan.nama_urusan
  end

  def opd_pemohon
    opd.nama_opd
  end

  def strategi_tactical
    if strategi.present?
      strategi.to_s
    else
      ''
    end
  end

  def status_rincian
    spbe_rincians.all?(&:diterima?)
  end

  def valid?
    strategi_tactical.present?
  end
end
