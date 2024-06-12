# frozen_string_literal: true

class SasaranKota::SubkegiatanComponent < ViewComponent::Base
  def initialize(subkegiatan:, tahun:)
    super
    @subkegiatan = subkegiatan # this is program_kegiatan model
    @tahun = tahun
  end

  def nama_subkegiatan
    @subkegiatan.nama_subkegiatan
  rescue NoMethodError
    'Belum diisi'
  end

  def pagu_subkegiatan
    pagu = @subkegiatan.pagu_rankir_tahun(@tahun)
    "Rp. #{number_with_delimiter(pagu)}"
  rescue NoMethodError
    'Rp. 0'
  end

  def warna_row
    'table-success'
  end
end
