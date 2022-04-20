json.results @programKegiatans do |program|
  json.id program.id
  json.text program.opd.nama_opd + ' | ' +program.nama_subkegiatan
end
