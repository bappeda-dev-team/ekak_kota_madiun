class Perhitungan < ApplicationRecord
  before_save :hitung_total
  before_update :hitung_total
  after_save :update_jumlah_anggaran
  after_update :update_jumlah_anggaran
  after_destroy :update_jumlah_anggaran

  belongs_to :anggaran
  has_many :koefisiens

  def hitung_total
    self.total = self.volume * self.harga
  end

  def update_jumlah_anggaran
    anggaran = self.anggaran
    if anggaran.perhitungans.any?
      anggaran.jumlah = anggaran.perhitungans.sum(:total)
      anggaran.save    
    end
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
