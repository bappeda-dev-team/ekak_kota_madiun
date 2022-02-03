# == Schema Information
#
# Table name: program_kegiatans
#
#  id                :bigint           not null, primary key
#  nama_program      :string
#  nama_kegiatan     :string
#  nama_subkegiatan  :string
#  indikator_kinerja :string
#  target            :string
#  satuan            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  opd_id            :integer
#
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

  def my_pagu
    self.sasarans.map { |s| s.rincian.total_anggaran }.compact.sum
  end
end
