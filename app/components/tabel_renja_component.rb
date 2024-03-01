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

  def pagu_urusan(kode_urusan, opd)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_urusan] == kode_urusan && prs[:kode_sub_opd] == opd }
      .sum { |sub| sub[:pagu] }
  end

  def bidang_urusan_opd(parent)
    @program_kegiatans[:bidang_urusan].select { |prs| prs[:parent] == parent }
  end

  def pagu_bidang_urusan(kode_bidang_urusan, opd)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_bidang_urusan] == kode_bidang_urusan && prs[:kode_sub_opd] == opd }
      .sum { |sub| sub[:pagu] }
  end

  def program_opd(parent, opd)
    @program_kegiatans[:program].select { |prs| prs[:parent] == parent && prs[:kode_opd] == opd }
  end

  def pagu_program(kode_program, opd)
    @program_kegiatans[:subkegiatan]
      .select { |prs| prs[:kode_program] == kode_program && prs[:kode_sub_opd] == opd }
      .sum { |sub| sub[:pagu] }
  end

  def kegiatan_opd(parent, opd)
    @program_kegiatans[:kegiatan].select { |prs| prs[:parent] == parent && prs[:kode_opd] == opd }
  end

  def pagu_kegiatan(kode_kegiatan, opd)
    subkegiatan_opd(kode_kegiatan, opd).sum { |sub| sub[:pagu] }
  end

  def subkegiatan_opd(parent, opd)
    @program_kegiatans[:subkegiatan].select { |prs| prs[:parent] == parent && prs[:kode_sub_opd] == opd }
  end
end
