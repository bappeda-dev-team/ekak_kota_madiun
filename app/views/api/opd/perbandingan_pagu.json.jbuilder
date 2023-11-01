json.message "Pagu OPD"
json.data do
  json.kode_opd @kode_opd
  json.nama_opd @nama_opd
  json.pagu_kak @anggaran_kak
  json.pagu_sipd @anggaran_opd
end
