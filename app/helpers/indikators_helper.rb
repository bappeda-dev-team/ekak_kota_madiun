module IndikatorsHelper
  def ind_prg(program, tahun, kode_opd)
    indikator_program = program.indikator_program_tahun(tahun, kode_opd)
  end
end
