module PohonTematikHelper
  def select_tematik(tematiks)
    options_for_select(tematiks.pluck(:tema, :id))
  end

  def select_opd(opds)
    options_for_select(opds.pluck(:nama_opd, :id))
  end

  def sub_pohon(collections, parent_id)
    collections.select do |coll|
      coll.pohon_ref_id == parent_id
    end
  end
end
