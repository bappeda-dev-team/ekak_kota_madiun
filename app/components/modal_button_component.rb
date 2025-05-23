# frozen_string_literal: true

class ModalButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Edit', icon: true, style: '')
    super
    @title = title
    @path = path
    @icon = icon
    @style = style
  end

  def btn_style
    @style.blank? ? 'btn btn-outline-info w-100' : @style
  end
end
