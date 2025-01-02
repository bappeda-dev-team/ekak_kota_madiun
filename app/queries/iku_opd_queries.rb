class IkuOpdQueries
  def initialize(kode_opd: '', tahun: '', periode: '')
    @kode_opd = kode_opd
    @tahun = tahun
    @periode = periode
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def pohon_opd
    StrategiPohon.includes(:pohon_shareds)
                 .by_periode(@periode)
                 .where(opd_id: opd.id, role: 'eselon_2')
                 .select { |pp| pp.deleted_at.nil? }
  end

  def tujuan_opd
    opd.tujuan_opds.by_periode(@tahun)
  end

  def sasaran_opd
    pohon_opd.flat_map(&:sasarans)
             .select { |ss| ss.tahun.present? }
             .compact_blank
  end

  def komponen_indikator
    sasaran_opd.flat_map(&:indikators).group_by(&:indikator_kinerja)
  end

  def komponen_iku
    tujuan_opd + sasaran_opd
  end

  def indikators_opd
    indikators = tujuan_opd + sasaran_opd
    indikators.flat_map(&:indikators).compact_blank
  end

  def iku_opd
    indikators_opd
  end
end
