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
    serapan_anggaran.growth_checker.sum do |bu|
      bu[:growth_check_pagu]
    end
  end

  # rubocop: disable Metrics
  def efektifitas_efisiensi_opd
    kinerja = pertumbuhan_capaian_kinerja
    anggaran = pertumbuhan_pagu_anggaran

    nilai_kinerja = if kinerja <= -100
                      'DATA BELUM TERISI'
                    elsif kinerja >= 0
                      'EFEKTIF'
                    else
                      'TIDAK EFEKTIF'
                    end

    nilai_anggaran = if anggaran <= -100
                       'DATA BELUM TERISI'
                     elsif anggaran <= 0 && nilai_kinerja == 'EFEKTIF'
                       'EFISIEN'
                     else
                       ''
                     end

    status_kinerja_anggaran = if kinerja <= -100 || anggaran <= -100
                                "DATA BELUM TERISI"
                              else
                                "#{nilai_kinerja} #{nilai_anggaran}"
                              end

    { kinerja: nilai_kinerja == 'EFEKTIF' ? kinerja : 0,
      kinerja_tidak_terisi: kinerja <= -100,
      anggaran: nilai_anggaran == 'EFISIEN' ? anggaran : 0,
      anggaran_tidak_terisi: anggaran <= -100,
      nilai_kinerja: nilai_kinerja,
      nilai_anggaran: nilai_anggaran,
      status: status_kinerja_anggaran }
  end
end
