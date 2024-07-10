# frozen_string_literal: true

class SasaranKota::ProgramPaguComponent < ViewComponent::Base
  def initialize(program:, pagu:, jenis:)
    super
    @program = program
    @pagu = pagu
    @jenis = jenis
  end

  def nama
    case @jenis
    when 'Urusan'
      @program.nama_urusan
    when 'Program'
      @program.nama_program
    when 'Kegiatan'
      @program.nama_giat
    when 'Subkegiatan'
      @program.nama_subkegiatan
    else
      ''
    end
  rescue NoMethodError
    'Belum diisi'
  end

  def urusan?
    role == 'eselon_2'
  end

  def program?
    role == 'eselon_3'
  end

  def subkegiatan?
    role == 'eselon_4'
  end

  def urusans
    programs.uniq(&:nama_urusan)
  end

  def programs
    program_pohon(@sasaran.pohonable, role)
  end

  def subkegiatans
    @sasaran.program_kegiatan
  end

end
