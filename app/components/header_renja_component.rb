# frozen_string_literal: true

class HeaderRenjaComponent < ViewComponent::Base
  def initialize(title: '', indikator: false, periode: [])
    super
    @title = title
    @periode = periode
    @indikator = indikator
  end

  def style_header
    "thead-#{@title.parameterize}"
  end
end
