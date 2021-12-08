class Rincian < ApplicationRecord
  belongs_to :sasaran
  has_many :kesenjangan
  has_many :tahapans
  accepts_nested_attributes_for :tahapans

  def method_missing(method, *args, &block)
    return 0
  end

  def target_bulan
    self.tahapans.map{|t| t.aksis.group(:bulan).sum(:target)}
  end

  def realisasi_bulan
    self.tahapans.map{|t| t.aksis.group(:bulan).sum(:realisasi)}
  end

  def total_target_aksi_bulan
    self.tahapans.map{|t| t.aksis.group(:bulan).sum(:target)}.inject{|bln, val| bln.merge(val) { |k, old_v, new_v| old_v + new_v} }
  end

  def total_realisasi_aksi_bulan
    self.tahapans.map{|t| t.aksis.group(:bulan).sum(:realisasi)}.inject{|bln, val| bln.merge(val) { |k, old_v, new_v| old_v + new_v} }
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
    ((jumlah_realisasi.to_f / jumlah_target.to_f ) * 100) rescue 0
  end

  def total_anggaran
    self.tahapans.map{ |t| t.anggarans.find_by(level: 0)}.sum{|n| n.jumlah}
  end

end
