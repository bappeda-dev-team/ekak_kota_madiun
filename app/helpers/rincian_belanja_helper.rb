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
    if hitung.deskripsi.downcase.include?('lain_lain') || hitung.spesifikasi.include?('Belanja Gaji')
      uraian = hitung.deskripsi
      spesifikasi = hitung.spesifikasi
      tahun = hitung.tahun
    else
      uraian = uraian_kode(hitung.deskripsi)
      spesifikasi = spesifikasi_anggaran(hitung.deskripsi)
      tahun = tahun_kode(hitung.deskripsi)
    end
    "#{uraian} <br/> #{spesifikasi} <br/> - #{tahun}".html_safe
  end

  def spesifikasi_anggaran(kode_barang)
    # update using delgate method polymorphic
    Search::AllAnggaran.find_by_kode_barang(kode_barang).spesifikasi
  rescue NoMethodError
    'Tidak Ditemukan'
  end

  def anggaran_gaji?(anggaran)
    anggaran.include?("gaji") or anggaran.include?("tunjangan") or anggaran.include?("penghasilan") or anggaran.include?("honor")
  end
end
