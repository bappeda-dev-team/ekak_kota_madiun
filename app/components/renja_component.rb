# frozen_string_literal: true

class RenjaComponent < ViewComponent::Base
  def initialize(program: '', head: true, anggaran: 0)
    super
    @program = program
    @head = head
    @anggaran = anggaran
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

  def kode_tweak
    if kode.scan(/\d+$/).last.size == 2 && jenis == 'subkegiatan'
      kode.gsub(/[.](?!.*[.])/, ".00\\1")
    else
      kode
    end
  end

  def nama
    @program[:nama]
  end

  def pagu
    pagu_anggaran = if jenis == 'subkegiatan'
                      @program[:pagu]
                    else
                      @anggaran
                    end
    "Rp. #{number_with_delimiter(pagu_anggaran)}"
  end

  def indikators
    @program[:indikators]
  end

  def with_indikator?
    allowed = %w[Program program Kegiatan kegiatan Subkegiatan subkegiatan]
    jenis.in? allowed
  end
end
