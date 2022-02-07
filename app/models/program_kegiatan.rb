# == Schema Information
#
# Table name: program_kegiatans
#
#  id                :bigint           not null, primary key
#  indikator_kinerja :string
#  nama_kegiatan     :string
#  nama_program      :string
#  nama_subkegiatan  :string
#  satuan            :string
#  target            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  opd_id            :integer
#

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
