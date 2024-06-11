# frozen_string_literal: true

class SasaranKota::ProgramComponent < ViewComponent::Base
  def initialize(program:, program_counter:, program_iteration:, warna_row:, sasaran:, tahun:)
    super
    @program = program
    @counter = program_counter + 1
    @iteration = program_iteration
    @warna_row = warna_row
    @sasaran = sasaran
    @tahun = tahun
  end

  def nama_program
    @program.nama_program
  end

  def sub_pohons
    @sasaran.sub_pohons.select(&:pohonable)
  end

  def pagu_program
    sasarans = sub_pohons.flat_map { |sub| sub.pohonable.sasarans.dengan_nip.group_by(&:program_kegiatan).keys }
    pagu = sasarans.flat_map { |prg| prg&.anggaran_sasarans(@tahun) }.compact.sum

    "Rp. #{number_with_delimiter(pagu)}"
  end

  def nomor
    @iteration.size > 1 ? @counter : ''
  end

  attr_reader :warna_row
end
