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
    StrategiPohon.by_periode(@periode)
                 .where(opd_id: opd.id, role: 'eselon_2')
                 .select { |pp| pp.deleted_at.nil? }
  end

  def tujuan_opd
    opd.tujuan_opds.by_periode(@periode.last)
  end

  def sasaran_opd
    pohon_opd.flat_map { |ph| ph.sasarans.includes(:indikator_sasarans) }
             .select { |ss| ss.tahun.present? }
             .compact_blank
  end

  def komponen_indikator_sasaran
    sasaran_opd.flat_map(&:indikators).group_by(&:indikator_kinerja)
  end

  def komponen_indikator_tujuan
    tujuan_opd.flat_map(&:indikators)
  end
end
