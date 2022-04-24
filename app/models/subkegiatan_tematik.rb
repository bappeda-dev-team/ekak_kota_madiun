# == Schema Information
#
# Table name: subkegiatan_tematiks
#
#  id           :bigint           not null, primary key
#  kode_tematik :string
#  nama_tematik :string
#  tahun        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class SubkegiatanTematik < ApplicationRecord
  has_many :program_kegiatans
  has_many :sasarans
  validates :kode_tematik, presence: true
  validates :nama_tematik, presence: true
end
