module LaporansHelper
  def pagu_sub(sasarans)
    pagu = sasarans.map(&:total_anggaran).compact.sum
    "
      <td class='border rankir-2'>Rp. #{number_with_delimiter(pagu)}</td>
    ".html_safe
  end

  def indikator_sub(subkegiatan, tahun, kode_opd)
    indikator = subkegiatan&.indikator_subkegiatan_tahun(tahun, kode_opd)
    "
      <td class='border text-wrap'>#{indikator&.dig(:indikator)}</td>
      <td class='border text-wrap'>#{indikator&.dig(:target)}</td>
      <td class='border text-wrap'>#{indikator&.dig(:satuan)}</td>
    ".html_safe
  end

  def rowspan_sasaran(sasaran)
    sasaran.indikator_sasarans.empty? ? 1 : sasaran.indikator_sasarans.length
  end

  def indikator_sasaran(sasaran)
    indikator = sasaran.indikator_sasarans.first
    "
      <td class='border text-wrap'>#{indikator&.indikator_kinerja}</td>
      <td class='border text-wrap'>#{indikator&.target}</td>
      <td class='border text-wrap'>#{indikator&.satuan}</td>
    ".html_safe
  end

  def row_indikator_sasaran(sasaran)
    sasaran.indikator_sasarans.drop(1).map do |indikator_s|
      "
        <tr>
          <td class='border text-wrap'>#{indikator_s.indikator_kinerja}</td>
          <td class='border text-wrap'>#{indikator_s.target}</td>
          <td class='border text-wrap'>#{indikator_s.satuan}</td>
        </tr>
      ".html_safe
    end
  end

  def row_tahapan_sasaran(sasaran)
    sasaran.tahapans.map do |tahapan|
      "
        <tr>
          <td class='border text-wrap' colspan='7'>Renaksi #{tahapan.urutan}: #{tahapan.tahapan_kerja}</td>
        </tr>
      ".html_safe
    end
  end

  def row_tahapan_anggaran_sasaran(sasaran)
    sasaran.tahapans.map do |tahapan|
      "
        <tr>
          <td class='border text-wrap' colspan='6'>Renaksi #{tahapan.urutan}: #{tahapan.tahapan_kerja}</td>
          <td class='border'>Rp. #{number_with_delimiter(tahapan.anggaran_tahapan)}</td>
          <td class='border'></td>
        </tr>
      ".html_safe
    end
  end
end
