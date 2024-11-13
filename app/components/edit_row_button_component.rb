# frozen_string_literal: true

class EditRowButtonComponent < ViewComponent::Base
  def initialize(btn_style: '', path: '', title: 'Edit', icon: 'fas fa-pencil-alt')
    super
    @title = title
    @path = path
    @icon = icon
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
    "<span class='#{@icon} me-2'></span>".html_safe
  end
end
