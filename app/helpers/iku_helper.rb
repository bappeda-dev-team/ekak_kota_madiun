module IkuHelper
  def target_iku(ind_targets, tahun)
    targets = ind_targets.select do |ind|
      tahun_bener = /murni|perubahan/.match?(ind.tahun) ? ind.tahun[/[^_]\d*/, 0] : ind.tahun
      tahun_bener == tahun.to_s
    end
    targets.first&.target
  end

  def satuan_iku(ind_targets)
    ind_targets.flat_map(&:satuan).uniq.last
  end

  def target_iku_tujuan(indikator_tujuan, tahun)
    indikator_tujuan.targets.find_by(tahun: tahun)&.target
  end

  def realisasi_iku_tujuan(indikator_tujuan, tahun)
    indikator_tujuan.realisasis.find_by(tahun: tahun)&.realisasi
  end

  def rasio_iku_tujuan(indikator_tujuan, tahun)
    rasio = indikator_tujuan.realisasis.find_by(tahun: tahun)&.capaian
    return '' if rasio.nil?

    "#{rasio}%"
  end

  def satuan_iku_tujuan(indikator_tujuan)
    indikator_tujuan.targets.flat_map(&:satuan).compact_blank.last
  end

  def satuan_realisasi_tujuan(indikator_tujuan)
    indikator_tujuan.realisasis.flat_map(&:satuan).compact_blank.last
  end

  def target_nspk_tujuan(indikator_tujuan)
    indikator_tujuan.target_nspks.last&.target
  end

  def target_ikks_tujuan(indikator_tujuan)
    indikator_tujuan.target_ikks.last&.target
  end

  def target_lainnyas_tujuan(indikator_tujuan)
    indikator_tujuan.target_lainnyas.last&.target
  end

  def pertumbuhan_target(indikator_tujuan, periode)
    target_hash = periode.to_h do |tahun|
      [tahun.to_i, target_iku_tujuan(indikator_tujuan, tahun).to_f]
    end
    growth_average(target_hash)
  end

  def pertumbuhan_realisasi(indikator_tujuan, periode)
    realisasi_hash = periode.to_h do |tahun|
      [tahun.to_i, realisasi_iku_tujuan(indikator_tujuan, tahun).to_f]
    end
    growth_average(realisasi_hash)
  end

  def pertumbuhan_capaian(indikator_tujuan, periode)
    capaian_hash = periode.to_h do |tahun|
      rasio = indikator_tujuan.realisasis.find_by(tahun: tahun)&.capaian
      [tahun.to_i, rasio.to_f]
    end
    growth_average(capaian_hash)
  end
end
