# frozen_string_literal: true

class SasaranKota::SasaranComponent < ViewComponent::Base
  include PohonKinerjaOpdsHelper

  def initialize(sasaran:, sasaran_iteration:, tahun:)
    super
    @sasaran = sasaran
    @counter = sasaran_iteration.index + 1
    @tahun = tahun
  end

  def renaksi
    if role == 'eselon_4'
      @sasaran.sasaran_kinerja
    else
      @sasaran.pohonable.to_s
    end
  end

  def opd
    @sasaran.opd.to_s
  end

  def keterangan
    @sasaran.keterangan
  end

  def indikators
    if role == 'eselon_4'
      @sasaran.indikator_sasarans
    else
      @sasaran.pohonable.indikators
    end
  end

  def warna_row
    case role
    when 'eselon_2'
      'table-danger'
    when 'eselon_3'
      'table-info'
    when 'eselon_4'
      'table-success'
    else
      ''
    end
  end

  def rowspan
    indikators.size + 1
  end

  # def program?
  #   allowed_roles = %w[eselon_2 eselon_3 sub_sub_pohon_kota sub_pohon_kota pohon_kota]
  #   role.in? allowed_roles
  # end

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

  def sub_pohons
    if role == 'eselon_3'
      @sasaran.sub_pohons.select(&:pohonable).flat_map { |ph| ph.pohonable.sasarans.dengan_nip }
    elsif role == 'eselon_4'
      []
    else
      @sasaran.sub_pohons.select(&:pohonable)
    end
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

  def jenis
    case @sasaran.role
    when 'strategi_pohon_kota'
      'sasaran_opd'
    when 'tactical_pohon_kota'
      'sasaran_program'
    when 'operational_pohon_kota'
      'sasaran_kegiatan'
    else
      'sasaran_kota'
    end
  end

  def title_up
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = case @sasaran.role
             when 'pohon_kota'
               'Tematik Kota'
             when 'sub_pohon_kota'
               'Sub-Tematik Kota'
             when 'sub_sub_pohon_kota'
               'Sub Sub-Tematik Kota'
             when 'strategi_pohon_kota'
               'Strategic'
             else
               @sasaran.role.chomp("_pohon_kota")
             end
    prefix.titleize
  end
end
