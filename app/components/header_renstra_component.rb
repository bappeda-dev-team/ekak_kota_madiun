# frozen_string_literal: true

class HeaderRenstraComponent < ViewComponent::Base
  attr_accessor :periode

  def initialize(title: '', indikator: false, periode: [])
    super
    @title = title
    @indikator = indikator
    @periode = periode
  end

  def style_header
    "thead-#{@title.parameterize.dasherize}"
  end
end
