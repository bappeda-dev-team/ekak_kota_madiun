module PohonTematikHelper
  def select_tematik(tematiks)
    options_for_select(tematiks.pluck(:tema, :id))
  end

  def select_pohon_tematik(tematiks)
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
                         ["#{str.strategi} - #{str.tahun}", str.id, { 'data-opd-id': str.opd_id }]
                       end)
  end

  def sub_pohon(collections, parent_id)
    collections.select do |coll|
      coll.pohon_ref_id == parent_id
    end
  end
end
