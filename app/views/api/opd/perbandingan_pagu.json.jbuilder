json.message "Pagu OPD"
json.data do
  json.kode_opd @kode_opd
  json.nama_opd @nama_opd
  json.subkegiatan_opd @anggaran_subkegiatans do |sub|
    json.kode_subkegiatan sub[:kode_subkegiatan]
    json.nama_subkegiatan sub[:nama_subkegiatan]
    json.pagu_kak sub[:pagu_subkegiatan_kak]
    json.pagu_sipd sub[:pagu_subkegiatan_sipd]
  end
end
