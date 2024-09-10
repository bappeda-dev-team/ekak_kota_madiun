# frozen_string_literal: true

class EditRowButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Edit', icon: 'fas fa-pencil-alt')
    super
    @title = title
    @path = path
    @icon = icon
  end

  def style
   'btn btn-sm btn-outline-info'
  end

  def icon
    "<span class='#{@icon} me-2'></span>".html_safe
  end
end
