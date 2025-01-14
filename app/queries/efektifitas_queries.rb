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
    iku_opd.iku_tujuan_targets.sum do |tar|
      tar[:growth_capaian]
    end
  end

  def pertumbuhan_pagu_anggaran
    serapan_anggaran.bidang_urusan_pagu.sum do |bu|
      bu[:growth_pagu]
    end
  end

  def efektifitas_efisiensi_opd
    kinerja = pertumbuhan_capaian_kinerja
    anggaran = pertumbuhan_pagu_anggaran

    nilai_kinerja = if kinerja >= 0
                      'EFEKTIF'
                    else
                      'TIDAK EFEKTIF'
                    end

    nilai_anggaran = if anggaran <= 0 && nilai_kinerja == 'EFEKTIF'
                       'EFISIEN'
                     else
                       ''
                     end

    status_kinerja_anggaran = "#{nilai_kinerja} #{nilai_anggaran}"

    { kinerja: kinerja,
      anggaran: anggaran,
      nilai_kinerja: nilai_kinerja,
      nilai_anggaran: nilai_anggaran,
      status: status_kinerja_anggaran }
  end
end
