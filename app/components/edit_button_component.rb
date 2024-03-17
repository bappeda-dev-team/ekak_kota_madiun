# frozen_string_literal: true

class EditButtonComponent < ViewComponent::Base
  def initialize(path: '')
    super
    @path = path
  end
end
