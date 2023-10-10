json.results @opds do |opd|
  json.urusan opd.urusan
  json.bidang_urusan opd.bidang_urusan
  json.kode_opd opd.kode_unik_opd
  json.nama_opd opd.nama_opd
end
