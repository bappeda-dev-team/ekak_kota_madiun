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

  def urusan_opd
    @program_kegiatans[:urusan]
  end

  def bidang_urusan_opd(parent)
    @program_kegiatans[:bidang_urusan].select { |prs| prs[:parent] == parent }
  end

  def program_opd(parent)
    @program_kegiatans[:program].select { |prs| prs[:parent] == parent }
  end

  def kegiatan_opd(parent)
    @program_kegiatans[:kegiatan].select { |prs| prs[:parent] == parent }
  end

  def subkegiatan_opd(parent)
    @program_kegiatans[:subkegiatan].select { |prs| prs[:parent] == parent }
  end
end
