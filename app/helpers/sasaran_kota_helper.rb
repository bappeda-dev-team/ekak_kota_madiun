module SasaranKotaHelper
  def rowspan_helper(pohon, sas)
    rowspan_ind = sas.pohonable.indikators.size + 1
    if pohon.role == 'eselon_4'
      rekins = pohon.rencana_kinerjas
      rowspan_rekins = rekins.nil? ? 1 : rekins.size
    else
      programs = program_pohon(pohon.pohonable, pohon.role)
      rowspan_rekins = programs.nil? ? 1 : programs.size
    end
    rowspan = rowspan_ind + rowspan_rekins
    { rowspan_ind: rowspan_ind, rowspan_rekins: rowspan_rekins, rowspan: rowspan }
  end
end
