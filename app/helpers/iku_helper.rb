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

  def satuan_iku_tujuan(indikator_tujuan)
    indikator_tujuan.targets.flat_map(&:satuan).uniq.last
  end
end
