class IkuOpdQueries
  include SerapanAnggaranHelper
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

  def komponen_indikator_iku
    Indikator.iku_opd
             .includes(%i[targets realisasis])
             .where(kode_opd: @kode_opd, tahun: @periode)
             .reorder('id ASC')
  end

  def komponen_indikator_sasaran
    iku_indikator = komponen_indikator_iku

    iku_sasaran = sasaran_opd.flat_map(&:indikators)

    # Filter `iku_sasaran` to exclude any entry whose `indikator` exists in `iku_indikator`
    filtered_iku_sasaran = iku_sasaran.reject do |sasaran|
      iku_indikator.any? { |indikator| indikator.indikator == sasaran.indikator_kinerja || !indikator.is_hidden }
    end

    filtered_iku_sasaran.select { |ff| ff.indikator_kinerja.present? }
                        .group_by(&:indikator_kinerja)
  end

  def komponen_indikator_tujuan
    iku_tujuan = tujuan_opd.flat_map(&:indikators)

    iku_tujuan + komponen_indikator_iku
  end

  def iku_tujuan_targets
    komponen_indikator_tujuan.map do |ind|
      {
        growth_capaian: growth_average(capaian_iku(ind))
      }
    end
  end

  def capaian_iku(indikator)
    indikator.targets.where(tahun: @periode).to_h do |tar|
      [tar.tahun.to_i, tar.capaian]
    end
  end
end
