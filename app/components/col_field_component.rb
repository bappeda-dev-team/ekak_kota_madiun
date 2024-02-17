# frozen_string_literal: true

class ColFieldComponent < ViewComponent::Base
  def initialize(width: '300px', el_class: '')
    super
    @width = width
    @el_class = el_class
  end

  def class_status
    "fw-bolder text-wrap #{@el_class}"
  end
end
