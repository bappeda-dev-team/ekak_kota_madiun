# frozen_string_literal: true

class SasaranKota::IndikatorComponent < ViewComponent::Base
  def initialize(indikator:, indikator_iteration:, warna_row:)
    super
    @indikator = indikator
    @iteration = indikator_iteration
    @warna_row = warna_row
  end

  def indikator
    @indikator.to_s
  end

  def target
    @indikator.target
  end

  def satuan
    @indikator.satuan
  end

  def rowspan_rkn
    @iteration.size + 1
  end
end
