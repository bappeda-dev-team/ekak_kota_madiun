# == Schema Information
#
# Table name: spbes
#
#  id                  :bigint           not null, primary key
#  jenis_pelayanan     :string
#  kode_opd            :string
#  kode_program        :string
#  nama_aplikasi       :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  strategi_ref_id     :string
#
class Spbe < ApplicationRecord
  belongs_to :program_kegiatan, -> { order "kode_program" }

  has_one :sasaran, -> { order "nip_asn ASC" }, primary_key: :strategi_ref_id, foreign_key: :id
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
  }

  def nama_program
    program_kegiatan.nama_program
  end
end
