# frozen_string_literal: true

class Pohon::FootComponent < ViewComponent::Base
  def initialize(item:)
    @item = item
  end

  def element_class_name
    @item.role.dasherize
  end

  def can_toggle_all?
    # change to detect first child item
    # rather than checking the type
    @item.pohonable_type == 'Tematik'
  end

end
