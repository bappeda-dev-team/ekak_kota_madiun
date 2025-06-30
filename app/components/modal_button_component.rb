# frozen_string_literal: true

class ModalButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Edit', icon: '', style: '')
    super
    @title = title
    @path = path
    @icon = icon
    @style = style
  end

  def btn_style
    @style.blank? ? 'btn btn-outline-info w-100' : @style
  end

  def btn_icon
    @icon.blank? ? 'fas fa-edit me-2' : @icon
  end
end
