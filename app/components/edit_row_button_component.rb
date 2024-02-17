# frozen_string_literal: true

class EditRowButtonComponent < ViewComponent::Base
  def initialize(path: '', title: 'Edit')
    super
    @title = title
    @path = path
  end
end
