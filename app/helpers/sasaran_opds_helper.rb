module SasaranOpdsHelper
  def indikator_sasaran_tambahan(sasaran)
    indikator = sasaran&.indikator_sasarans&.first
    "
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.indikator_kinerja}</td>
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.rumus_perhitungan}</td>
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.sumber_data}</td>
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.target}</td>
      <td class='border text-wrap spbe-kebutuhan'>#{indikator&.satuan}</td>
    ".html_safe
  end

  def row_indikator_sasaran_tambahan(sasaran)
    sasaran.indikator_sasarans.drop(1).map do |indikator_s|
      "
        <tr>
          <td class='border text-wrap'>#{indikator_s.indikator_kinerja}</td>
          <td class='border text-wrap'>#{indikator&.rumus_perhitungan}</td>
          <td class='border text-wrap'>#{indikator&.sumber_data}</td>
          <td class='border text-wrap'>#{indikator_s.target}</td>
          <td class='border text-wrap'>#{indikator_s.satuan}</td>
        </tr>
      ".html_safe
    end
  end
end
