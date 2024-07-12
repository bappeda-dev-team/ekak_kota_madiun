# frozen_string_literal: true

class SasaranKota::ProgramPaguComponent < ViewComponent::Base
  include PohonKinerjaOpdsHelper

  def initialize(sasaran:, pagu: 0)
    super
    @sasaran = sasaran
    @pagu = pagu
  end

  def sasaran_pohon
    @sasaran.pohonable
  end

  def pagu_sub_sasaran
    @sasaran.sub_pohons.select(&:pohonable).flat_map do |strategic|
      childs = strategic.sub_pohons.flat_map { |sub| sub.sub_pohons.flat_map(&:pohonable) }.compact_blank
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
      sasarans.flat_map(&:total_anggaran).compact_blank.sum
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
    case role
    when 'eselon_2'
      childs = @sasaran.sub_pohons.flat_map { |sub| sub.sub_pohons.flat_map(&:pohonable) }.compact_blank
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
      urusans = sasarans.group_by do |sas|
        "#{sas.program_kegiatan.nama_urusan}-(#{sas.program_kegiatan.kode_urusan})"
      end
      urusans.transform_values { |sas| sas.map(&:total_anggaran).compact_blank.sum }
    when 'eselon_3'
      childs = @sasaran.sub_pohons.flat_map(&:pohonable).compact_blank
      sasarans = childs.flat_map(&:sasarans).select { |sas| sas.program_kegiatan.presence }.compact_blank
      programs = sasarans.group_by do |sas|
        "#{sas.program_kegiatan.nama_program}-(#{sas.program_kegiatan.kode_program})"
      end
      programs.transform_values { |sas| sas.map(&:total_anggaran).compact_blank.sum }
    when 'eselon_4'
      sasarans = @sasaran.pohonable.sasarans.select { |sas| sas.program_kegiatan.presence }.compact_blank
      kegiatans = sasarans.group_by do |sas|
        "#{sas.program_kegiatan.nama_kegiatan}-(#{sas.program_kegiatan.kode_giat})"
      end
      kegiatans.transform_values { |sas| sas.map(&:total_anggaran).compact_blank.sum }
    else
      []
    end
  end

  def subkegiatan
    return unless role == 'sub_eselon_4'

    [@sasaran.subkegiatan_kode_sub, @sasaran.total_anggaran]
  end
end
