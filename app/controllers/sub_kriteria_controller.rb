class SubKriteriaController < KriteriaController
  def new
    @kriterium = SubKriterium.new(kriteria_id: params[:parent])
  end
end
