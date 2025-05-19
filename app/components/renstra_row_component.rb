# frozen_string_literal: true

class RenstraRowComponent < ViewComponent::Base
  include UsersHelper
  include Devise::Controllers::Helpers
  attr_reader :periode, :parent

  def initialize(program: '', head: true, anggaran: 0, periode: [], cetak: true, parent: '', jenis_periode: 'RPJMD')
    super
    @program = program
    @head = head
    @anggaran = anggaran
    @periode = periode
    @cetak = cetak
    @parent = parent
    @jenis_periode = jenis_periode
  end

  def jenis
    @program[:jenis]
  end

  def title
    jenis.capitalize
  end

  def kode_opd
    if @program[:jenis] == 'subkegiatan'
      @program[:kode_sub_opd]
    else
      @program[:kode_opd]
    end
  end

  def kode
    @program[:kode]
  end

  def kode_tweak
    if kode.scan(/\d+$/).last&.size == 2 && jenis == 'subkegiatan'
      kode.gsub(/[.](?!.*[.])/, ".00\\1")
    else
      kode
    end
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
      parent: @parent,
      jenis: 'Renstra',
      sub_jenis: title,
      sub_sub_jenis: @jenis_periode,
      tahun_awal: @periode.first,
      tahun_akhir: @periode.last
    )
  end

  def row_id
    "#{kode}-#{kode_opd}"
  end
end
