class SubKriteriaController < KriteriaController
  include ActionView::RecordIdentifier

  def new
    @kriterium = SubKriterium.new(kriteria_id: params[:parent])
    @target = dom_parent
  end

  private

  def dom_parent
    parent = Kriterium.find(params[:parent])
    dom_id(parent)
  rescue StandardError
    ''
  end
end
