json.results @opds do |opd|
  json.kode_opd opd.kode_unik_opd
  json.nama_opd opd.nama_opd
  json.nama_kepala_opd opd.nama_kepala
  json.nip_kepala_opd opd.nip_kepala
end
