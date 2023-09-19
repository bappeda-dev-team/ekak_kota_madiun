module PohonKinerjaOpdsHelper
  def child_strategi(parent, childs)
    childs.select { |str| str.pohon_ref_id.to_i == parent.id }
  rescue NoMethodError
    []
  end

  def childs(pohon_kinerja_opd)
    case pohon_kinerja_opd.role
    when 'eselon_2'
      child_strategi(pohon_kinerja_opd, @tactical_opd)
    when 'strategi_pohon_kota'
      child_strategi(pohon_kinerja_opd, @tactical_kota)
    when 'eselon_3'
      child_strategi(pohon_kinerja_opd, @operational_opd)
    when 'tactical_pohon_kota'
      child_strategi(pohon_kinerja_opd, @operational_kota)
    else
      child_strategi(pohon_kinerja_opd, @staff_opd)
    end
  end
end
