# == Schema Information
#
# Table name: tahapans
#
#  id               :bigint           not null, primary key
#  bulan            :string
#  jumlah_realisasi :integer
#  jumlah_target    :integer
#  keterangan       :string
#  progress         :integer
#  realisasi        :integer
#  tahapan_kerja    :string
#  target           :integer
#  waktu            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  sasaran_id       :bigint
#
# Indexes
#
#  index_tahapans_on_sasaran_id  (sasaran_id)
#
class Tahapan < ApplicationRecord
  belongs_to :sasaran, optional: true
  has_many :aksis, dependent: :destroy
  has_many :anggarans, dependent: :destroy

  validates :tahapan_kerja, presence: true

  def find_target_bulan(bulan)
    aksis.find_by_bulan(bulan).target
  rescue NoMethodError
    '-'
  end
  
  def target_total
    jumlah_target.nil? ? '-' : jumlah_target
  end
  
  def anggaran_tahapan
    anggarans.compact.sum { |n| n.jumlah }
  rescue NoMethodError
    '0'
  end
end
