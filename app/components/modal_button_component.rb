# frozen_string_literal: true

class ModalButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Edit')
    super
    @title = title
    @path = path
  end
end
