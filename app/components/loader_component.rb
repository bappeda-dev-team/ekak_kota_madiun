# frozen_string_literal: true

class LoaderComponent < ViewComponent::Base
  def initialize(text: 'memuat data..')
    super
    @text = text
  end
end
