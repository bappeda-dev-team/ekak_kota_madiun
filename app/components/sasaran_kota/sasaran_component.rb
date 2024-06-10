# frozen_string_literal: true

class SasaranKota::SasaranComponent < ViewComponent::Base
  include PohonKinerjaOpdsHelper

  def initialize(sasaran:, sasaran_iteration:)
    super
    @sasaran = sasaran
    @counter = sasaran_iteration.index + 1
  end

  def renaksi
    @sasaran.pohonable.to_s
  end

  def opd
    @sasaran.opd.to_s
  end

  def keterangan
    @sasaran.keterangan
  end

  def indikators
    @sasaran.pohonable.indikators
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
      'table-light'
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

  def programs
    program_pohon(@sasaran.pohonable, role)
  end

  def subkegiatans
    @sasaran.pohonable.sasarans.dengan_nip
  end

  def sub_pohons
    @sasaran.sub_pohons.select(&:pohonable)
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
end
