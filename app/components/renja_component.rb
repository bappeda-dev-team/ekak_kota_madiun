# frozen_string_literal: true

class RenjaComponent < ViewComponent::Base
  def initialize(program: '', tahun: '', jenis: '', head: true)
    super
    @program = program
    @tahun = tahun
    @jenis = jenis
    @head = head
  end

  def title
    @jenis.capitalize
  end

  def nama_kode
    case @jenis
    when 'program' || 'Program'
      [@program.kode_program, @program.nama_program]
    when 'kegiatan' || 'Kegiatan'
      [@program.kode_giat, @program.nama_kegiatan]
    when 'subkegiatan' || 'Subkegiatan'
      [@program.kode_sub_giat, @program.nama_subkegiatan]
    else
      @jenis
    end
  end

  def kode
    nama_kode[0]
  end

  def nama
    nama_kode[1]
  end

  def kode_opd
    @kode_opd ||= @program.kode_sub_skpd
  end

  def indikator_program_kegiatan
    @indikator_program_kegiatan ||= @program.indikator_renstras_alt_new(@jenis, kode_opd, @tahun)
  end

  def indikator
    indikator_program_kegiatan&.indikator || '-'
  end

  def target
    indikator_program_kegiatan&.target || '-'
  end

  def satuan
    indikator_program_kegiatan&.satuan || '-'
  end

  def pagu_indikator
    if @jenis == 'subkegiatan'
      indikator_program_kegiatan&.pagu || 0
    else
      indikator_program_kegiatan&.sum_pagu_renstra(sub_jenis: 'Subkegiatan') || 0
    end
  end

  def pagu
    "Rp. #{number_with_delimiter(pagu_indikator)}"
  end

  def keterangan
    indikator_program_kegiatan&.keterangan
  end
end
