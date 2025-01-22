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

  def indikator_sasaran_opd
    sasaran_opd.flat_map(&:indikator_sasarans).uniq
  end

  def indikator_iku
    Indikator.iku_opd
             .includes(%i[targets realisasis])
             .where(kode_opd: @kode_opd, tahun: @periode)
             .reorder('id ASC')
  end

  def hidden_indikators
    indikator_iku.hidden
  end

  def komponen_indikator_iku
    indikator_iku = hidden_indikators.where(is_hidden: true).flat_map(&:indikator)
    indikator_sasaran = indikator_sasaran_opd.flat_map(&:indikator_kinerja)
    filtered = filter_indikator_sasaran(indikator_iku, indikator_sasaran)
    indikators = hidden_indikators.where(is_hidden: false)
    indikators.select do |ind|
      filtered.include?(ind.indikator)
    end
  end

  def komponen_indikator_sasaran
    indikator_iku = hidden_indikators.flat_map(&:indikator)
    filtered_iku_sasaran = indikator_sasaran_opd.reject do |ind_sasaran|
      indikator_iku.include?(ind_sasaran.indikator_kinerja)
    end

    filtered_iku_sasaran.group_by(&:indikator_kinerja)
  end

  def filter_indikator_sasaran(indikator_iku, indikator_sasaran)
    (indikator_iku - indikator_sasaran) + (indikator_sasaran - indikator_iku)
  end

  def komponen_indikator_tujuan
    iku_tujuan = tujuan_opd.flat_map { |tuj| tuj.indikators.shown }

    iku_tujuan + komponen_indikator_iku
  end

  def iku_tujuan_targets
    komponen_indikator_tujuan.map do |ind|
      {
        growth_capaian: growth_average_iku(capaian_iku(ind))
      }
    end
  end

  def capaian_iku(indikator)
    indikator.targets.where(tahun: @periode).to_h do |tar|
      [tar.tahun.to_i, tar.capaian]
    end
  end
end
