# frozen_string_literal: true

class SasaranKota::ProgramComponent < ViewComponent::Base
  def initialize(program:, program_counter:, program_iteration:, warna_row:)
    super
    @program = program
    @counter = program_counter + 1
    @iteration = program_iteration
    @warna_row = warna_row
  end

  def nama_program
    @program.nama_program
  end

  def nomor
    @iteration.size > 1 ? @counter : ''
  end

  attr_reader :warna_row
end
