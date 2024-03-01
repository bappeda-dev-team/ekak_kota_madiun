# frozen_string_literal: true

class TabelRenjaComponent < ViewComponent::Base
  def initialize(program_kegiatans: {}, jenis_renja: '')
    super
    @program_kegiatans = program_kegiatans
    @jenis_renja = jenis_renja
  end

  def sub_opd
    @program_kegiatans[:sub_opd]
  end

  def pagu_sub_opd(kode_sub_opd)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_sub_opd] == kode_sub_opd }
      .sum { |sub| sub[:pagu] }
  end

  def urusan_opd
    @program_kegiatans[:urusan]
  end

  def pagu_urusan(kode_urusan)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_urusan] == kode_urusan }
      .sum { |sub| sub[:pagu] }
  end

  def bidang_urusan_opd(parent)
    @program_kegiatans[:bidang_urusan].select { |prs| prs[:parent] == parent }
  end

  def pagu_bidang_urusan(kode_bidang_urusan)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_bidang_urusan] == kode_bidang_urusan }
      .sum { |sub| sub[:pagu] }
  end

  def program_opd(parent)
    @program_kegiatans[:program].select { |prs| prs[:parent] == parent }
  end

  def pagu_program(kode_program)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_program] == kode_program }
      .sum { |sub| sub[:pagu] }
  end

  def kegiatan_opd(parent)
    @program_kegiatans[:kegiatan].select { |prs| prs[:parent] == parent }
  end

  def pagu_kegiatan(kode_kegiatan)
    subkegiatan_opd(kode_kegiatan).sum { |sub| sub[:pagu] }
  end

  def subkegiatan_opd(parent)
    @program_kegiatans[:subkegiatan].select { |prs| prs[:parent] == parent }
  end
end
