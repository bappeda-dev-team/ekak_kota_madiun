json.results @mandatoris do |mandatori|
  json.tahun mandatori.tahun
  json.usulan mandatori.usulan
  json.alamat mandatori.peraturan_terkait
  json.uraian mandatori.uraian
  json.pengusul mandatori.asn_pengusul
  json.status mandatori.status
end
