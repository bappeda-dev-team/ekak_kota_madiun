# frozen_string_literal: true

class HeaderRenjaComponent < ViewComponent::Base
  def initialize(title: '', indikator: false)
    super
    @title = title
    @indikator = indikator
  end

  def style_header
    "thead-#{@title.parameterize}"
  end
end
