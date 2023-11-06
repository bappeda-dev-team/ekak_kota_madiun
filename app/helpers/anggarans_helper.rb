module AnggaransHelper
  def anggaran_level(kode_rekening)
    panjang_kode = kode_rekening.length
    case panjang_kode
    when 12
      3
    when 9
      2
    when 6
      1
    when 0..5
      0
    else
      4
    end
  end

  def rekening_anggaran(id_rekening)
    rekening = Rekening.find(id_rekening)
    if rekening
      rekening.kode_rekening
    else
      id_rekening
    end
  end

  def uraian_kode(kode_barang, tahun)
    # update using delgate method polymorphic
    Search::AllAnggaran.find_by(kode_barang: kode_barang, tahun: tahun).uraian_barang
  rescue NoMethodError
    'Tidak Ditemukan'
  end

  def spesifikasi(kode_barang)
    # update using delgate method polymorphic
    Search::AllAnggaran.find_by_kode_barang(kode_barang).spesifikasi
  rescue NoMethodError
    'Tidak Ditemukan'
  end

  def tahun_kode(kode_barang)
    # update using delgate method polymorphic

    # TODO test this

    finder = Search::AllAnggaran.find_by_kode_barang(kode_barang)
    type = finder.searchable_type
    id_type = finder.searchable_id
    type.constantize.find(id_type).tahun || '2022'
  rescue NoMethodError
    'Tidak Ditemukan'
  end

  def find_rekening(kode_rekening)
    Rekening.find_by(kode_rekening: kode_rekening)
  end
end
