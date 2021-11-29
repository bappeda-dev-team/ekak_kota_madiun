# table program_kegiatans
# t.string :nama_program
# t.string :nama_kegiatan
# t.string :nama_subkegiatan
# t.string :indikator_kinerja
# t.string :target
# t.string :satuan

class ProgramKegiatan < ApplicationRecord
  validates :nama_program, presence: true
  validates :indikator_kinerja, presence: true
  validates :target, presence: true
  validates :satuan, presence: true
  belongs_to :opd
  has_many :kaks
  has_many :sasarans
end
