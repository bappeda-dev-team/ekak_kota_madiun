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
  # before_save :hitung_total
  # before_update :hitung_total
  after_save :update_jumlah_anggaran
  # after_update :update_jumlah_anggaran
  # after_destroy :update_jumlah_anggaran

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
      total_harga = volume * harga
      pajak_anggaran = anggaran.pajak.potongan
      total_plus_pajak = total_harga * pajak_anggaran
      total_akhir = total_harga + total_plus_pajak.to_i
      puts 'end here'
      update(total: total_akhir)
    else
      total_akhir = 0
      update(total: total_akhir)
    end
  end

  def total_harga
    if koefisiens.any?
      total_volume = []
      koefisiens.map do |k|
        total_volume << k.volume
      end
      volume = total_volume.reduce(:*)
      total_harga = volume * harga
      pajak_anggaran = anggaran.pajak.potongan
      total_plus_pajak = total_harga * pajak_anggaran
      total_harga + total_plus_pajak.to_i
    else
      0
    end
  end

  def update_jumlah_anggaran
    update_column(:total, total_harga)
    anggaran.update_jumlah_anggaran
  end

  def list_koefisien
    koefisiens.map { |m| "#{m.volume} #{m.satuan_volume}" }.join(' x ')
  end
end
