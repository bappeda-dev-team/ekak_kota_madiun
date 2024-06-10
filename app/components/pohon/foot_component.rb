# frozen_string_literal: true

class Pohon::FootComponent < ViewComponent::Base
  def initialize(item:, is_root: false)
    @item = item
    @is_root = is_root
  end

  def element_class_name
    @item.role.dasherize
  end

  def can_toggle_all?
    # change to detect first child item
    # rather than checking the type
    @is_root
  end
end
