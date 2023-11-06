module RincianBelanjaHelper
  def link_edit_anggaran(anggaran, hitung)
    if hitung.deskripsi.downcase.include?('lain_lain')
      edit_lain_lain_anggaran_perhitungan_path(anggaran, hitung)
    elsif hitung.spesifikasi.include?('Belanja Gaji')
      edit_gaji_anggaran_perhitungan_path(anggaran, hitung)
    else
      edit_anggaran_perhitungan_path(anggaran, hitung)
    end
  end

  def uraian_rincian_anggaran(hitung)
    tahun = hitung.tahun
    if hitung.deskripsi.downcase.include?('lain_lain') || hitung.spesifikasi.include?('Belanja Gaji')
      uraian = hitung.deskripsi
      spesifikasi = hitung.spesifikasi
    else
      uraian = uraian_kode(hitung.deskripsi, hitung.tahun)
      spesifikasi = spesifikasi_anggaran(hitung.deskripsi, hitung.tahun)
    end
    "#{uraian} <br/> #{spesifikasi} <br/> - #{tahun}".html_safe
  end

  def spesifikasi_anggaran(kode_barang, tahun)
    # update using delgate method polymorphic
    Search::AllAnggaran.find_by(kode_barang: kode_barang, tahun: tahun).spesifikasi
  rescue NoMethodError
    'Tidak Ditemukan'
  end

  def anggaran_gaji?(anggaran)
    anggaran.include?("gaji") or
      anggaran.include?("tunjangan") or
      anggaran.include?("penghasilan") or
      anggaran.include?("honor") or
      anggaran.include?("iuran") or
      anggaran.include?("jaminan") or
      anggaran.include?("retribusi") or
      anggaran.include?("pengelolaan") or
      anggaran.include?("terduga") or
      anggaran.include?("jasa")
  end
end
