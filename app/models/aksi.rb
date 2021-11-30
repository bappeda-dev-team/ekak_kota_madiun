class Aksi < ApplicationRecord
  belongs_to :tahapan
  after_save :update_total_target_bulan
  after_save :update_total_realisasi_bulan
  after_update :update_total_target_bulan
  after_update :update_total_realisasi_bulan
  after_destroy  :update_total_target_bulan
  after_destroy  :update_total_realisasi_bulan
  

  
  def update_total_target_bulan
    tahapan = self.tahapan
    tahapan.jumlah_target = tahapan.aksis.sum :target
    tahapan.save
  end

  def update_total_realisasi_bulan
    tahapan = self.tahapan
    tahapan.jumlah_realisasi = tahapan.aksis.sum :realisasi
    tahapan.save
  end


end
