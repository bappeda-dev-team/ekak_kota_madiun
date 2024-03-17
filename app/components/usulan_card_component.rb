# frozen_string_literal: true

class UsulanCardComponent < ViewComponent::Base
  def initialize(sasaran:, jenis:)
    @sasaran = sasaran
    @jenis = jenis
    @usulan_type = @jenis.capitalize
  end

  def title
    judul = case @jenis
            when 'pokpir'
              'Pokok Pikiran DPRD'
            when 'inovasi'
              'Inisiatif'
            else
              @jenis.capitalize
            end
    "Usulan #{judul}"
  end

  def usulans
    @sasaran.usulans.where(usulanable_type: @usulan_type).map(&:usulanable)
  end
end
