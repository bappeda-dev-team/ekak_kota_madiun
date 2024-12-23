class IkuOpdQueries
  extend Memoist

  def initialize(kode_opd: '', tahun: '', periode: '')
    @kode_opd = kode_opd
    @tahun = tahun
    @periode = periode
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_opd)
  end

  def pohon_opd
    StrategiPohon.where(opd_id: opd.id, tahun: @tahun)
                 .includes(:indikators, :pohon_shareds)
  end
  memoize :pohon_opd

  def tujuan_opd
    opd.tujuan_opds.by_periode(@tahun)
  end

  def sasaran_opd
    pohon_opd.where(role: "eselon_2")
             .select { |pp| pp.deleted_at.nil? }
             .flat_map(&:sasarans)
             .compact_blank
  end

  def indikators_opd
    indikators = tujuan_opd + sasaran_opd
    indikators.flat_map(&:indikators).compact_blank
  end

  def iku_opd
    indikators_opd
  end
end
