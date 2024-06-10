# frozen_string_literal: true

class SasaranKota::SubkegiatanComponent < ViewComponent::Base
  def initialize(subkegiatan:, subkegiatan_counter:, subkegiatan_iteration:, warna_row:)
    super
    @subkegiatan = subkegiatan # this is sasaran model
    @counter = subkegiatan_counter + 1
    @iteration = subkegiatan_iteration
    @warna_row = warna_row
  end

  def nama_subkegiatan
    @subkegiatan.nama_subkegiatan
  rescue NoMethodError
    'Belum diisi'
  end

  def pagu_subkegiatan
    pagu = @subkegiatan.anggaran_sasarans('2023_perubahan')
    "Rp. #{number_with_delimiter(pagu)}"
  rescue NoMethodError
    'Rp. 0'
  end

  def nomor
    @iteration.size > 1 ? @counter : ''
  end

  attr_reader :warna_row
end
