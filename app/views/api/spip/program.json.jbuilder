json.results @program_kegiatans do |opd|
  json.nama_opd opd[:opd]
  json.kode_opd opd[:kode_opd]
  json.set! :program, opd[:program]
end
