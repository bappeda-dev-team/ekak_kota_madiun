# frozen_string_literal: true

class SasaranKota::ProgramPaguComponent < ViewComponent::Base
  include PohonKinerjaOpdsHelper

  def initialize(sasaran:, pagu:)
    super
    @sasaran = sasaran
    @pagu = pagu
  end

  def sasaran_pohon
    @sasaran.pohonable
  end

  # ambil dari ProgramKegiatan
  def program
    @sasaran.program_kegiatan
  end

  def pagu_program
    'Rp. XXX XXX'
  end

  def role
    case @sasaran.role
    when 'strategi_pohon_kota'
      'eselon_2'
    when 'tactical_pohon_kota'
      'eselon_3'
    when 'operational_pohon_kota'
      'eselon_4'
    else
      @sasaran.role
    end
  end

  def jenis_program
    case role
    when 'eselon_2'
      'Urusan'
    when 'eselon_3'
      'Program'
    when 'eselon_4'
      'Kegiatan'
    else
      'Sub Sasaran'
    end
  end

  def programs
    program_pohons = program_pohon(@sasaran.pohonable, role)
    case role
    when 'eselon_2'
      program_pohons.flat_map(&:nama_urusan).compact_blank.uniq
    when 'eselon_3'
      program_pohons.flat_map(&:nama_program).compact_blank.uniq
    when 'eselon_4'
      program_pohons.flat_map(&:nama_kegiatan).compact_blank.uniq
    else
      []
    end
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

  def subkegiatans
    @sasaran.program_kegiatan
  end
end
