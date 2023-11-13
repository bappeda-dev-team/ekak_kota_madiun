json.results @pokpirs do |pokir|
  json.tahun pokir.tahun
  json.usulan pokir.usulan
  json.alamat pokir.alamat
  json.uraian pokir.uraian
  json.opd pokir.opd
  json.pengambil_usulan pokir.asn_pengambil
  json.status pokir.status
end
