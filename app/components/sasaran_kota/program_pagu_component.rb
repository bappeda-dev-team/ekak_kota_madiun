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

  def pagu_sub_sasaran
    @sasaran.sub_pohons.select(&:pohonable).flat_map do |strategic|
      anggaran_pohon(strategic.pohonable, 'eselon_2')
    end.compact_blank.sum
  end

  def role
    case @sasaran.role
    when 'strategi_pohon_kota'
      'eselon_2'
    when 'tactical_pohon_kota'
      'eselon_3'
    when 'operational_pohon_kota'
      'eselon_4'
    when 'sub_operational_pohon_kota'
      'sub_eselon_4'
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
    when 'sub_eselon_4'
      'Subkegiatan'
    else
      'Sub Sasaran'
    end
  end

  def programs
    program_pohons = program_pohon(@sasaran.pohonable, role)
    pagu_pohons = pagu_pohon(@sasaran.pohonable, role)
    case role
    when 'eselon_2'
      [program_pohons.flat_map(&:nama_urusan).compact_blank.uniq, pagu_pohons]
    when 'eselon_3'
      [program_pohons.flat_map(&:nama_program).compact_blank.uniq, pagu_pohons]
    when 'eselon_4'
      [program_pohons.flat_map(&:nama_kegiatan).compact_blank.uniq, pagu_pohons]
    else
      []
    end
  end

  def subkegiatan
    return unless role == 'sub_eselon_4'

    [@sasaran.subkegiatan, @sasaran.total_anggaran]
  end

  def subkegiatans
    @sasaran.program_kegiatan
  end
end
