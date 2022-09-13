# return renstra by opd and program
class RenstraService
  attr_accessor :kode_program, :kode_unik_opd, :tahun

  def initialize(kode_unik_opd:, kode_program: nil, tahun: nil)
    @kode_unik_opd = kode_unik_opd
    @kode_program = kode_program
    @tahun = tahun
    @opd = opd
    @program_kegiatan = program_kegiatan
  end

  def program_renstra
    program_opd.indikator_program_renstra
  end

  def program_opd
    program_kegiatan_opd.programs
  end

  def indikator_program
    @program_kegiatan.indikator_program_renstra
  end

  def program_kegiatan_opd
    @opd.program_kegiatans
  end

  def program_kegiatan
    ProgramKegiatan.find_by(kode_program: @kode_program)
  end

  def programs
    @program_kegiatans = @opd.program_kegiatans.programs
  end

  def kegiatans
    programs.map do |prog|
      prog.kegiatans
    end
  end

  def opd
    Opd.find_by(kode_unik_opd: @kode_unik_opd)
  end
end
