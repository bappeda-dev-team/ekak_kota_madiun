json.results @program_kegiatans do |program|
  json.tahun program.tahun
  json.kode_urusan program.kode_urusan
  json.urusan program.nama_urusan
  json.kode_bidang_urusan program.kode_bidang_urusan
  json.bidang_urusan program.nama_bidang_urusan
  json.kode_program program.kode_program
  json.program program.nama_program
  json.indikator_program program.indikator_program
  json.target program.target_program
  json.satuan program.satuan_target_program
  json.kode_opd program.opd.kode_unik_opd
  json.isu_strategis program.isu_strategis
end
