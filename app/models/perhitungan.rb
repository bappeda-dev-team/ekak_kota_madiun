# == Schema Information
#
# Table name: perhitungans
#
#  id          :bigint           not null, primary key
#  deskripsi   :string
#  harga       :integer
#  satuan      :string
#  spesifikasi :text
#  total       :integer
#  volume      :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  anggaran_id :bigint
#
# Indexes
#
#  index_perhitungans_on_anggaran_id  (anggaran_id)
#
class Perhitungan < ApplicationRecord
  before_save :hitung_total
  before_update :hitung_total
  after_save :update_jumlah_anggaran
  after_update :update_jumlah_anggaran
  after_destroy :update_jumlah_anggaran

  belongs_to :anggaran
  has_many :koefisiens
  accepts_nested_attributes_for :koefisiens

  validates :deskripsi, presence: true # uraian
  validates :satuan, presence: true
  validates :harga, presence: true, numericality: true

  def hitung_total
    # cek koefisien di perhitungan
    if koefisiens.any?
      # array total volume
      # dan meloop untuk insert semua volume
      total_volume = []
      koefisiens.map do |k|
        total_volume << k.volume
      end
      # hitung volume ( seluruh volume dikalikan )
      # pajak mengambil data dari anggaran diatasnya
      volume = total_volume.reduce(:*)
      total = volume * harga
      pajak = total * anggaran.pajak.potongan
      self.total = total + pajak.to_i
    else
      self.total = 0
    end
  end

  def update_jumlah_anggaran
    anggaran = self.anggaran
    if anggaran.perhitungans.any?
      anggaran.jumlah = anggaran.perhitungans.sum(:total)
      anggaran.save
    else
      anggaran.jumlah = 0
      anggaran.save
    end
    if anggaran.childs.any?
      level_4 = anggaran.parent
      level_4.jumlah = level_4.childs.sum(:jumlah)
      level_4.save

      level_3 = level_4.parent
      level_3.jumlah = level_3.childs.sum(:jumlah)
      level_3.save

      level_2 = level_3.parent
      level_2.jumlah = level_2.childs.sum(:jumlah)
      level_2.save

      level_1 = level_2.parent
      level_1.jumlah = level_1.childs.sum(:jumlah)
      level_1.save

      level_0 = level_1.parent
      level_0.jumlah = level_0.childs.sum(:jumlah)
      level_0.save
    end
  end
  
  def list_koefisien
    koefisiens.map { |m| "#{m.volume} #{m.satuan_volume}" }.join(' x ')
  end
end
