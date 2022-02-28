# == Schema Information
#
# Table name: sasarans
#
#  id                  :bigint           not null, primary key
#  anggaran            :integer
#  id_struktur         :string
#  indikator_kinerja   :string
#  kualitas            :integer
#  penerima_manfaat    :string
#  sasaran_kinerja     :string
#  satuan              :string
#  tahun               :integer
#  target              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  program_kegiatan_id :bigint
#  user_id             :bigint
#
# Indexes
#
#  index_sasarans_on_program_kegiatan_id  (program_kegiatan_id)
#  index_sasarans_on_user_id              (user_id)
#
class Sasaran < ApplicationRecord
  belongs_to :user
  belongs_to :program_kegiatan, optional: true

  has_many :musrenbangs
  has_many :tahapans
  has_one :rincian, dependent: :destroy

  accepts_nested_attributes_for :rincian, update_only: true
  accepts_nested_attributes_for :tahapans
  # TODO ganti kualitas dengan aspek ( multiple choice )
  #validation
  validates :sasaran_kinerja, presence: true
  validates :indikator_kinerja, presence: true
  validates :target, presence: true
  validates :satuan, presence: true

   def method_missing(method, *args, &block)
    return 0
  end

  # method yang ada map nya memang sengaja begitu, karena dibuat collection dan di loop untuk footer bulan
  def target_bulan
    self.tahapans.map { |t| t.aksis.group(:bulan).sum(:target) }
  end

  def realisasi_bulan
    self.tahapans.map { |t| t.aksis.group(:bulan).sum(:realisasi) }
  end

  def total_target_aksi_bulan
    self.tahapans.map { |t| t.aksis.group(:bulan).sum(:target) }.inject { |bln, val| bln.merge(val) { |k, old_v, new_v| old_v + new_v } }
  end

  def total_realisasi_aksi_bulan
    self.tahapans.map { |t| t.aksis.group(:bulan).sum(:realisasi) }.inject { |bln, val| bln.merge(val) { |k, old_v, new_v| old_v + new_v } }
  end

  def waktu_total
    begin
      self.total_target_aksi_bulan.count
    rescue NoMethodError => e
      print_exception(e, true)
    end
  end

  def progress_total
    jumlah_target = self.tahapans.sum :jumlah_target
    jumlah_realisasi = self.tahapans.sum :jumlah_realisasi
    ((jumlah_realisasi.to_f / jumlah_target.to_f) * 100) rescue 0
  end

  def total_anggaran
    self.tahapans.map { |t| t.anggarans.compact.sum { |n| n.jumlah } }.inject(:+)
  end
end
