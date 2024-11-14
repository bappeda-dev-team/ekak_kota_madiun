# frozen_string_literal: true

class EditColButtonComponent < ViewComponent::Base
  def initialize(path:, title: 'Edit', btn_style: '')
    super
    @path = path
    @title = title
    @btn_style = btn_style
  end

  def style
    if @btn_style.blank?
      'btn btn-sm btn-outline-info'
    else
      @btn_style
    end
  end

  def icon
    "<span class='fas fa-pencil-alt me-2'></span>".html_safe
  end
end
