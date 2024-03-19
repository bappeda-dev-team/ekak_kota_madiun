# frozen_string_literal: true

class RenstraRowComponent < ViewComponent::Base
  attr_reader :periode

  def initialize(program: '', head: true, anggaran: 0, periode: [], cetak: true)
    super
    @program = program
    @head = head
    @anggaran = anggaran
    @periode = periode
    @cetak = cetak
  end

  def jenis
    @program[:jenis]
  end

  def title
    jenis.capitalize
  end

  def kode
    @program[:kode]
  end

  def nama
    @program[:nama]
  end

  def pagu(tahun)
    if jenis == 'subkegiatan'
      @program[:pagu][tahun]
    else
      @anggaran[tahun]
    end
  end

  def indikators
    @program[:indikators]
  end

  def with_indikator?
    allowed = %w[Program program Kegiatan kegiatan Subkegiatan subkegiatan]
    jenis.in? allowed
  end
end
