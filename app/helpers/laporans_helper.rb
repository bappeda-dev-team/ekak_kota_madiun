module LaporansHelper
  def pagu_sub(sasarans)
    pagu = sasarans.map(&:total_anggaran).compact.sum
    "
      <td class='border rankir-2'>Rp. #{number_with_delimiter(pagu)}</td>
    ".html_safe
  end

  def indikator_sub(subkegiatan, tahun, kode_opd)
    tahun_n = tahun_fix(tahun)
    indikator = subkegiatan&.indikator_subkegiatan_tahun(tahun_n, kode_opd)
    "
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:indikator)}</td>
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:target)}</td>
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:satuan)}</td>
    ".html_safe
  end

  def indikator_keg(kegiatan, tahun, kode_opd)
    tahun_n = tahun_fix(tahun)
    indikator = kegiatan&.indikator_kegiatan_tahun(tahun_n, kode_opd)
    "
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:indikator)}</td>
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:target)}</td>
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:satuan)}</td>
    ".html_safe
  end

  def indikator_prg(program, tahun, kode_opd)
    tahun_n = tahun_fix(tahun)
    indikator = program&.indikator_program_tahun(tahun_n, kode_opd)
    "
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:indikator)}</td>
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:target)}</td>
      <td class='border text-wrap fw-bolder'>#{indikator&.dig(:satuan)}</td>
    ".html_safe
  end

  def rowspan_sasaran(sasaran)
    return 1 if sasaran.nil?

    sasaran.indikator_sasarans.empty? ? 1 : sasaran.indikator_sasarans.length
  end

  def indikator_sasaran(sasaran)
    indikator = sasaran&.indikator_sasarans&.first
    "
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.indikator_kinerja}</td>
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.target}</td>
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.satuan}</td>
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

  def row_tahapan_sasaran(sasaran, colspan: 7)
    sasaran.tahapans.map do |tahapan|
      "
        <tr>
          <td class='border text-wrap' colspan='#{colspan}'>Renaksi #{tahapan.urutan}: #{tahapan.tahapan_kerja}</td>
        </tr>
      ".html_safe
    end
  end

  def row_tahapan_anggaran_sasaran(sasaran, colspan: 6)
    sasaran.tahapans.map do |tahapan|
      "
        <tr>
          <td class='border text-wrap' colspan='#{colspan}'>Renaksi #{tahapan.urutan}: #{tahapan.tahapan_kerja}</td>
          <td class='border'>Rp. #{number_with_delimiter(tahapan.anggaran_tahapan)}</td>
          <td class='border'></td>
        </tr>
      ".html_safe
    end
  end

  def tahun_fix(tahun)
    tahun.match(/murni|perubahan/) ? tahun[/[^_]\d*/, 0] : tahun
  end

  def rekin_user(rekins, user_id)
    rekins.filter { |_sub, rks| rks.select { |rk| rk.user.id == user_id } }
  end
end
