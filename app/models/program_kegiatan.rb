# == Schema Information
#
# Table name: program_kegiatans
#
#  id                        :bigint           not null, primary key
#  indikator_kinerja         :string
#  indikator_subkegiatan     :string
#  kode_opd                  :string
#  nama_kegiatan             :string
#  nama_program              :string
#  nama_subkegiatan          :string
#  satuan                    :string
#  satuan_target_subkegiatan :string
#  target                    :string
#  target_subkegiatan        :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  subkegiatan_tematik_id    :bigint
#
# Indexes
#
#  index_program_kegiatans_on_subkegiatan_tematik_id  (subkegiatan_tematik_id)
#
# Foreign Keys
#
#  fk_rails_...  (kode_opd => opds.kode_opd)
#  fk_rails_...  (subkegiatan_tematik_id => subkegiatan_tematiks.id)
#

class ProgramKegiatan < ApplicationRecord
  validates :nama_program, presence: true
  validates :indikator_kinerja, presence: true
  validates :target, presence: true
  validates :satuan, presence: true
  belongs_to :opd, foreign_key: 'kode_opd', primary_key: 'kode_opd'
  belongs_to :subkegiatan_tematik, optional: true
  has_many :kaks
  has_many :sasarans

  def my_pagu
    sasarans.map(&:total_anggaran).compact.sum
  end
end
