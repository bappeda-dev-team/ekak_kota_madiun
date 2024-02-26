# frozen_string_literal: true

class RenjaComponent < ViewComponent::Base
  def initialize(program: '', periode: '', jenis: '', head: true)
    super
    @program = program
    @periode = periode
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
    else
      [@program.kode_sub_giat, @program.nama_subkegiatan]
    end
  end

  def kode
    nama_kode[0]
  end

  def nama
    nama_kode[1]
  end
end
