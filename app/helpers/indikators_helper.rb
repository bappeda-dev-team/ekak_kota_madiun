module IndikatorsHelper
  def ind_prg(program, tahun, kode_opd)
    program.indikator_program_tahun(tahun, kode_opd)
  end
end
