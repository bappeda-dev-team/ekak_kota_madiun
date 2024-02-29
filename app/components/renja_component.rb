# frozen_string_literal: true

class RenjaComponent < ViewComponent::Base
  def initialize(program: '', head: true)
    super
    @program = program
    @head = head
  end

  def nama_kode
    @program
  end

  def title
    nama_kode[:jenis].capitalize
  end

  def kode
    nama_kode[:kode]
  end

  def nama
    nama_kode[:nama]
  end

  def pagu
    "Rp. #{number_with_delimiter(@program[:pagu])}"
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

  def pagu_non_program
    jumlah = @collections.flat_map do |subs|
      subs.indikator_renstras_alt_new('program', subs.kode_sub_skpd, @tahun)
          &.sum_pagu_renstra(sub_jenis: 'Subkegiatan')
    end

    jumlah.inject(0) { |inj, pagu| inj + pagu.to_i }
  end

  # TODO: fix kalau pelaksana pindah / pensiun
  def hitung_pagu_rankir
    @hitung_pagu_rankir ||= @program.pagu_sub_rankir_tahun(@tahun, kode_opd)
  end

  def pagu_rankir
    if with_indikator?
      if @jenis == 'subkegiatan'
        hitung_pagu_rankir
      else
        @collections.map { |prg| prg.pagu_sub_rankir_tahun(@tahun, kode_opd) }.sum
      end
    else
      @collections.map { |prg| prg.pagu_sub_rankir_tahun(@tahun, prg.kode_sub_skpd) }.sum
    end
  end

  def keterangan
    indikator_program_kegiatan&.keterangan
  end

  def with_indikator?
    allowed = %w[Program program Kegiatan kegiatan Subkegiatan subkegiatan]
    @jenis.in? allowed
  end

  def rankir?
    @jenis_renja == 'rankir'
  end
end
