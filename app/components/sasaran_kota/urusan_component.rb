# frozen_string_literal: true

class SasaranKota::UrusanComponent < ViewComponent::Base
  def initialize(urusan:, urusan_counter:, urusan_iteration:, warna_row:)
    super
    @urusan = urusan
    @counter = urusan_counter + 1
    @iteration = urusan_iteration
    @warna_row = warna_row
  end

  def nama_urusan
    @urusan.nama_urusan
  end

  def nomor
    @iteration.size > 1 ? @counter : ''
  end

  attr_reader :warna_row
end
