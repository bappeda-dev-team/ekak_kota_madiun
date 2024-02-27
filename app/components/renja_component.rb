# frozen_string_literal: true

class RenjaComponent < ViewComponent::Base
  def initialize(program: '', tahun: '',
                 jenis: '', head: true,
                 jenis_renja: '',
                 collections: '')
    super
    @program = program
    @tahun = tahun
    @jenis = jenis
    @head = head
    @collections = collections
    @jenis_renja = jenis_renja
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
      @program
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

  def pagu_non_program
    jumlah = @collections.flat_map do |subs|
      subs.indikator_renstras_alt_new('program', subs.kode_sub_skpd, @tahun)
          &.sum_pagu_renstra(sub_jenis: 'Subkegiatan')
    end

    jumlah.inject(0) { |inj, pagu| inj + pagu.to_i }
  end

  def pagu
    if rankir?
      "Rp. #{number_with_delimiter(pagu_rankir)}"
    elsif with_indikator?
      "Rp. #{number_with_delimiter(pagu_indikator)}"
    else
      "Rp. #{number_with_delimiter(pagu_non_program)}"
    end
  end

  def pagu_rankir
    if @jenis == 'subkegiatan'
      ProgramKegiatan
        .where(kode_sub_giat: nama_kode[0],
               kode_sub_skpd: kode_opd).map do |sub|
        sub.sasarans.lengkap_strategi_tahun(@tahun).map(&:total_anggaran).compact.sum
      end.sum
    else
      5000
      # @collections.map do |subkegiatan|
      #   subkegiatan.map { |pp| pp.pagu_sub_rankir_tahun(@tahun) }.compact.sum
      # end
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
