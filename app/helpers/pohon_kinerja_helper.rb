module PohonKinerjaHelper
  def nama_eselon(eselon)
    case eselon
    when 'eselon_2'
      'level_1'
    when 'eselon_2b'
      'level_1b'
    when 'eselon_3'
      'level_2'
    when 'eselon_4'
      'level_3'
    else
      'level_4'
    end
  end

  def opd_khusus?(opd_id)
    [145, 122, 123].include?(opd_id)
  end

  def role_opd_khusus(opd_id)
    if [145, 122, 123].include?(opd_id)
      %w[eselon_2b eselon_3]
    else
      'eselon_3'
    end
  end

  def pembagi_strategi(pohon)
    strategi = pohon&.strategi
    pemilik = pohon&.nama_pemilik
    "
      <span>#{strategi}</span>
        <hr/>
      <span class='fw-bolder'>#{pemilik}</span>
    ".html_safe
  end

  def data_jumlah_strategi(rekap_jumlah)
    "<ul>
            <li>Jumlah Strategic Objective : #{rekap_jumlah[:strategic]}</li>
            <li>Jumlah Indikator : #{rekap_jumlah[:strategic_indikator]}</li>
            <li>Jumlah Tactical Objective : #{rekap_jumlah[:tactical]}</li>
            <li>Jumlah Indikator : #{rekap_jumlah[:tactical_indikator]}</li>
            <li>Jumlah Operational Objective : #{rekap_jumlah[:operational]}</li>
            <li>Jumlah Indikator : #{rekap_jumlah[:operational_indikator]}</li>
            <li>Jumlah Operational Objective 2 : #{rekap_jumlah[:operational2]} </li>
            <li>Jumlah Indikator : #{rekap_jumlah[:operational2_indikator]}</li>
          </ul>".html_safe
  end

  def strategi_matcher(strategis, parent_id)
    strategis.select do |strategi|
      parent = if strategi.strategi_ref_id.blank?
                 strategi.pohon.pohonable_id.to_i
               else
                 strategi.strategi_ref_id.to_i
               end
      parent == parent_id
    end
  end

  def selected_pohon(pohon, pohon_id)
    options_for_select([[pohon, pohon_id]], selected: pohon_id)
  end

  def list_pohon(pohons, selected)
    options_for_select(pohons, selected: selected)
  end

  def map_eselon_strategi(eselon)
    case eselon
    when 'eselon_2'
      'Strategic'
    when 'eselon_2b'
      'Strategic 2'
    when 'eselon_3'
      'Tactical'
    when 'eselon_4'
      'Operational'
    else
      'Operational 2'
    end
  end
end
