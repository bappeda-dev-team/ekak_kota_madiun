json.message 'Dasar Hukum'
json.tahun @tahun
json.kode_opd @kode_opd
json.nama_opd @opd.nama_opd
json.dasar_hukums @dasar_hukums.each do |das_hu|
  json.jenis das_hu.class.name.titleize
  json.judul das_hu.dasar_hukum
  json.peraturan das_hu.peraturan
end
