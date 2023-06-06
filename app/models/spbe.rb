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

  has_many :spbe_rincians, -> { order "id ASC" }
  accepts_nested_attributes_for :spbe_rincians, reject_if: :all_blank, allow_destroy: true

  def nama_program
    program_kegiatan.nama_program
  end
end
