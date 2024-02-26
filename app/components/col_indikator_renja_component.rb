# frozen_string_literal: true

class ColIndikatorRenjaComponent < ViewComponent::Base
  def initialize(tahun, jenis, program_kegiatan)
    super
    @tahun = tahun
    @jenis = jenis
    @program_kegiatan = program_kegiatan
  end

  def kode_opd
    @kode_opd ||= @program_kegiatan.kode_sub_skpd
  end

  def indikator_program_kegiatan
    @indikator_program_kegiatan ||= @program_kegiatan.indikator_renstras_alt_new(@jenis, kode_opd, @tahun)
  end

  def indikator
    indikator_program_kegiatan.indikator
  end

  def target
    indikator_program_kegiatan.target
  end

  def satuan
    indikator_program_kegiatan.satuan
  end

  def pagu
    pagu_ind = indikator_program_kegiatan.pagu
    "Rp. #{number_with_delimiter(pagu_ind)}"
  end

  def keterangan
    indikator_program_kegiatan.keterangan
  end
end
