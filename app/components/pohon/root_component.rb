# frozen_string_literal: true

class Pohon::RootComponent < ViewComponent::Base
  def initialize(title: 'Tematik Kota', subtitle: '')
    @title = title
    @subtitle = subtitle
  end
end
