# frozen_string_literal: true

class DeleteRowButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Hapus', message: 'Hapus ?')
    super
    @title = title
    @path = path
    @message = message
  end

  def style
    'btn btn-sm btn-outline-danger'
  end

  def icon
    "<span class='fas fa-trash-alt me-2'></span>".html_safe
  end
end
