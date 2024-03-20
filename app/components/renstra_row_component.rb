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

  def kode_opd
    @program[:kode_opd]
  end

  def kode
    @program[:kode]
  end

  def nama
    @program[:nama]
  end

  def pagu(tahun)
    @anggaran[tahun]
  end

  def indikators
    @program[:indikators]
  end

  def with_indikator?
    allowed = %w[Program program Kegiatan kegiatan Subkegiatan subkegiatan]
    jenis.in? allowed
  end

  def with_aksi?
    allowed = %w[Program program Kegiatan kegiatan Subkegiatan subkegiatan]
    jenis.in? allowed
  end

  def edit_path
    edit_indikator_renstra_index_path(
      nama: nama,
      kode_opd: kode_opd,
      kode: kode,
      jenis: 'Renstra',
      sub_jenis: title,
      tahun_awal: @periode.first,
      tahun_akhir: @periode.last
    )
  end

  def row_id
    "#{kode}-#{kode_opd}"
  end
end
