class EfektifitasQueries
  def initialize(kode_opd: '', tahun: '', periode: '')
    @kode_opd = kode_opd
    @tahun = tahun
    @periode = periode
    @tahun_awal = periode.first
    @tahun_akhir = periode.last
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def serapan_anggaran
    SerapanQueries.new(tahun: @tahun, kode_opd: @kode_opd, periode: @periode)
  end

  def iku_opd
    IkuOpdQueries.new(tahun: @tahun, kode_opd: @kode_opd, periode: @periode)
  end

  def pertumbuhan_capaian_kinerja
    10
  end

  def pertumbuhan_serapan_anggaran
    0
  end

  def efektifitas_efisiensi_opd
    kinerja = pertumbuhan_capaian_kinerja
    anggaran = pertumbuhan_serapan_anggaran

    nilai_kinerja = if kinerja >= 0
                      'EFEKTIF'
                    else
                      'TIDAK EFEKTIF'
                    end

    nilai_anggaran = if anggaran <= 0
                       'EFISIEN'
                     else
                       ''
                     end
    { kinerja: kinerja,
      anggaran: anggaran,
      nilai_kinerja: nilai_kinerja,
      nilai_anggaran: nilai_anggaran }
  end
end
