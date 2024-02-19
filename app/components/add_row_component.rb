# frozen_string_literal: true

class AddRowComponent < ViewComponent::Base
  def initialize(path: '', title: 'Tambah Baru', target: 'new')
    super
    @path = path
    @title = title
    @target = target
  end
end
