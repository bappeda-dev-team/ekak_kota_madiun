module RencanaAksiOpdsHelper
  def rowspan_renaksi_opd(sasaran)
    return 1 if sasaran.nil?

    indikator_row = sasaran.indikator_sasarans.empty? ? 1 : sasaran.indikator_sasarans.length # 4
    renaksi_row = sasaran.rencana_aksi_opds.empty? ? 1 : sasaran.rencana_aksi_opds.length # 3
    rowspan_rumit = indikator_row + renaksi_row - 1

    sasaran.indikator_sasarans.empty? ? 1 : rowspan_rumit
  end

  def indikator_rencana_aksi_opd(sasaran)
    indikator = sasaran&.indikator_sasarans&.first
    rowspan = if sasaran.indikator_sasarans.length == 1
                sasaran.rencana_aksi_opds.empty? ? 1 : sasaran.rencana_aksi_opds.length
              else
                1
              end
    "
      <td rowspan='#{rowspan}' class='border text-wrap indikator-sasaran'>#{indikator&.indikator_kinerja}</td>
      <td rowspan='#{rowspan}' class='border text-wrap indikator-sasaran'>#{indikator&.target}</td>
      <td rowspan='#{rowspan}' class='border text-wrap indikator-sasaran'>#{indikator&.satuan}</td>
    ".html_safe
  end

  def row_indikator_rencana_aksi_opd(sasaran)
    rowspan = sasaran.rencana_aksi_opds.empty? ? 1 : sasaran.rencana_aksi_opds.size
    sasaran.indikator_sasarans.drop(1).map do |indikator_s|
      if indikator_s == sasaran.indikator_sasarans.last
        "
        <tr class='last indikator-sasaran'>
          <td rowspan='#{rowspan}' class='border text-wrap'>#{indikator_s.indikator_kinerja}</td>
          <td rowspan='#{rowspan}' class='border text-wrap'>#{indikator_s.target}</td>
          <td rowspan='#{rowspan}' class='border text-wrap'>#{indikator_s.satuan}</td>
        </tr>
      ".html_safe
      else
        "
        <tr class='indikator-sasaran'>
          <td class='border text-wrap'>#{indikator_s.indikator_kinerja}</td>
          <td class='border text-wrap'>#{indikator_s.target}</td>
          <td class='border text-wrap'>#{indikator_s.satuan}</td>
        </tr>
      ".html_safe
      end
    end
  end
end
