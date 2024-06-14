module PohonTematikHelper
  def select_tematik(tematiks)
    options_for_select(tematiks.pluck(:tema, :id))
  end

  def select_pohon_tematik(tematiks)
    tematiks = tematiks.reject { |tema| tema.pohonable.nil? }
    options_for_select(tematiks.collect { |tema| [tema.pohonable.tema, tema.pohonable_id] })
  end

  def select_opd(opds)
    options_for_select(opds.pluck(:nama_opd, :id))
  end

  def selected_opd(opds, selected)
    options_for_select(opds.pluck(:nama_opd, :id), selected: selected)
  end

  def select_strategi(strategis)
    options_for_select(strategis.map do |str|
                         [str.strategi, str.id, { 'data-opd-id': str.opd_id }]
                       end)
  end

  def sub_pohon(collections, parent_id)
    collections.select do |coll|
      coll.pohon_ref_id == parent_id
    end
  end

  def childs_tematik_kota(parent, childs)
    childs.select do |str|
      str.pohon_ref_id.to_i == parent.id
    end
  rescue NoMethodError
    []
  end

  def childs_tematik(pohon_tematik)
    childss = case pohon_tematik.role
              when 'pohon_kota'
                merge_role = @sub_tematik_kota.or(@strategi_tematiks)
                childs_tematik_kota(pohon_tematik, merge_role)
              when 'sub_pohon_kota'
                merge_role = @sub_sub_tematik_kota.or(@strategi_tematiks)
                childs_tematik_kota(pohon_tematik, merge_role)
              when 'sub_sub_pohon_kota'
                childs_tematik_kota(pohon_tematik, @strategi_tematiks)
              when 'strategi_pohon_kota'
                childs_tematik_kota(pohon_tematik, @tactical_tematiks)
              when 'tactical_pohon_kota'
                childs_tematik_kota(pohon_tematik, @operational_tematiks)
              end
    childss&.select(&:pohonable)
  end
end
