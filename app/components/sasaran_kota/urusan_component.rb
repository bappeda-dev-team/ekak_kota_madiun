# frozen_string_literal: true

class SasaranKota::UrusanComponent < ViewComponent::Base
  def initialize(urusan:, urusan_counter:, urusan_iteration:, warna_row:, sasaran:, tahun:)
    super
    @urusan = urusan
    @counter = urusan_counter + 1
    @iteration = urusan_iteration
    @warna_row = warna_row
    @sasaran = sasaran
    @tahun = tahun
  end

  def nama_urusan
    @urusan.nama_urusan
  end

  def sub_pohons
    @sasaran.sub_pohons.select(&:pohonable)
            .flat_map { |sub| sub.sub_pohons.select(&:pohonable) }
  end

  def pagu_urusan
    sasarans = sub_pohons.flat_map { |sub| sub.pohonable.sasarans.dengan_nip.group_by(&:program_kegiatan).keys }
    pagu = sasarans.flat_map { |prg| prg&.anggaran_sasarans(@tahun) }.compact.sum

    "Rp. #{number_with_delimiter(pagu)}"
  end

  def nomor
    @iteration.size > 1 ? @counter : ''
  end

  attr_reader :warna_row
end
