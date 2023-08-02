module PohonTematikHelper
  def select_tematik(tematiks)
    options_for_select(tematiks.pluck(:tema, :id))
  end

  def sub_pohon(collections, parent_id)
    collections.select do |coll|
      coll.pohon_ref_id == parent_id
    end
  end
end
