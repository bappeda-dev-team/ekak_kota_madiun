# frozen_string_literal: true

class Pohon::BodyOpdComponent < ViewComponent::Base

  def initialize(item:)
    super
    @item = item
  end

  def pohon
    presenter
  end

  def presenter
    PohonKinerjaPresenter.new(@item)
  end
end
