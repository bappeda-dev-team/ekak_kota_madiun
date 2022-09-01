json.results @program_kegiatans do |program|
  json.kode_program program.kode_program
  json.tahun program.tahun
  json.program program.nama_program
  json.indikator_program program.indikator_program
  json.target program.target_program
  json.satuan program.satuan_target_program
  json.kode_opd program.opd.kode_unik_opd
end
