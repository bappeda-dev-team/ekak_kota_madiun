module TujuanKotaHelper
  def rowspan_tujuan_kota(tujuan_kota)
    size_indikator = tujuan_kota.indikator_tujuans.size
    if size_indikator.positive?
      size_indikator + 1
    else
      2
    end
  end
end
