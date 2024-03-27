# frozen_string_literal: true

class TabelRenstraComponent < ViewComponent::Base
  attr_reader :periode

  def initialize(program_kegiatans: {}, periode: '', cetak: true)
    super
    @program_kegiatans = program_kegiatans
    @periode = periode
    @cetak = cetak
  end

  def kode_parent(program)
    if program[:jenis] == 'subkegiatan'
      "#{program[:parent]}-#{program[:kode_sub_opd]}"
    else
      "#{program[:parent]}-#{program[:kode_opd]}"
    end
  end

  def opd_induk
    @program_kegiatans[:opd]
  end

  def total_pagu_opd
    subkegiatans = @program_kegiatans[:subkegiatan]
    periode.to_h do |tahun|
      [tahun, subkegiatans.sum { |sub| sub[:pagu][tahun] }]
    end
  end

  def sub_opd
    @program_kegiatans[:sub_opd]
  end

  def pagu_sub_opd(kode_sub_opd)
    subkegiatans = @program_kegiatans[:subkegiatan]
                   .select { |prs| prs[:kode_sub_opd] == kode_sub_opd }

    periode.to_h do |tahun|
      [tahun, subkegiatans.sum { |sub| sub[:pagu][tahun] }]
    end
  end

  def urusan_opd
    @program_kegiatans[:urusan]
  end

  def pagu_urusan(kode_urusan, opd)
    subkegiatans = @program_kegiatans[:subkegiatan]
                   .select { |prs| prs[:kode_urusan] == kode_urusan && prs[:kode_sub_opd] == opd }

    periode.to_h do |tahun|
      [tahun, subkegiatans.sum { |sub| sub[:pagu][tahun] }]
    end
  end

  def bidang_urusan_opd(parent)
    @program_kegiatans[:bidang_urusan].select { |prs| prs[:parent] == parent }
  end

  def pagu_bidang_urusan(kode_bidang_urusan, opd)
    subkegiatans = @program_kegiatans[:subkegiatan]
                   .select { |prs| prs[:kode_bidang_urusan] == kode_bidang_urusan && prs[:kode_sub_opd] == opd }

    periode.to_h do |tahun|
      [tahun, subkegiatans.sum { |sub| sub[:pagu][tahun] }]
    end
  end

  def program_opd(parent, opd)
    @program_kegiatans[:program].select { |prs| prs[:parent] == parent && prs[:kode_opd] == opd }
  end

  def pagu_program(kode_program, opd)
    subkegiatans = @program_kegiatans[:subkegiatan]
                   .select { |prs| prs[:kode_program] == kode_program && prs[:kode_sub_opd] == opd }

    periode.to_h do |tahun|
      [tahun, subkegiatans.sum { |sub| sub[:pagu][tahun] }]
    end
  end

  def kegiatan_opd(parent, opd)
    @program_kegiatans[:kegiatan].select { |prs| prs[:parent] == parent && prs[:kode_opd] == opd }
  end

  def pagu_kegiatan(kode_kegiatan, opd)
    periode.to_h do |tahun|
      [tahun, subkegiatan_opd(kode_kegiatan, opd).sum { |sub| sub[:pagu][tahun] }]
    end
  end

  def subkegiatan_opd(parent, opd)
    @program_kegiatans[:subkegiatan].select { |prs| prs[:parent] == parent && prs[:kode_sub_opd] == opd }
  end
end
