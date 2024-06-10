# frozen_string_literal: true

class SasaranKota::SubkegiatanComponent < ViewComponent::Base
  def initialize(subkegiatan:, subkegiatan_counter:, subkegiatan_iteration:, warna_row:)
    super
    @subkegiatan = subkegiatan
    @counter = subkegiatan_counter + 1
    @iteration = subkegiatan_iteration
    @warna_row = warna_row
  end

  def nama_subkegiatan
    @subkegiatan.to_s
  end

  def nomor
    @iteration.size > 1 ? @counter : ''
  end

  attr_reader :warna_row
end
