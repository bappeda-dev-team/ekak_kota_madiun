module PohonTematikHelper
  def select_tematik(tematiks)
    options_for_select(tematiks.pluck(:tema, :id))
  end
end
