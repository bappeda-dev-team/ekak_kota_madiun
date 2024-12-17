# frozen_string_literal: true

class ButtonAjaxComponent < ViewComponent::Base
  def initialize(title:, path:)
    super
    @title = title
    @path = path
  end

  def icon
    "<i class='fas fa-plus-square me-2'></i>".html_safe
  end
end
