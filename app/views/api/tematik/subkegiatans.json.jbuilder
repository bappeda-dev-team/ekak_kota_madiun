json.message "Data Subkegiatan Tematik - KAK"
json.data do
  json.tematik @tematik.tema
  json.tahun @tahun
  json.jumlah_pagu @jumlah
  json.opd @opds do |opd, subkegiatans|
    json.kode_opd opd[0]
    json.nama_opd opd[1]
    json.pagu_total subkegiatans.values.sum
    json.subkegiatan_opd subkegiatans do |subkegiatan, pagu|
      json.kode_subkegiatan subkegiatan[0]
      json.nama_subkegiatan subkegiatan[1]
      json.pagu pagu
    end
  end
end
