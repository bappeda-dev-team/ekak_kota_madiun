module AnggaransHelper

  def anggaran_level(kode_rekening)
    panjang_kode = kode_rekening.length
    case panjang_kode
      when 12
        level = 3
      when 9
        level = 2
      when 6
        level = 1
      when 0..5
        level = 0
      else
        level = 4
    end
    return level
  end
end
