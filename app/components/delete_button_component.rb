# frozen_string_literal: true

class DeleteButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Hapus')
    super
    @path = path
    @title = title
  end
end
