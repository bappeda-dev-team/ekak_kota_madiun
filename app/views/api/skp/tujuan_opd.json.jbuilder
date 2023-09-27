json.message "Tujuan OPD"
json.data do
  json.tahun @tahun
  json.kode_opd @opd.kode_unik_opd
  json.opd @opd.nama_opd
  json.jumlah_tujuan @tujuan_opds.size
  json.tujuan_opds @tujuan_opds do |tujuan_opd|
    json.id_tujuan tujuan_opd.id
    json.id_urusan tujuan_opd.urusan&.id
    json.kode_urusan tujuan_opd.urusan&.kode_urusan
    json.urusan tujuan_opd.urusan&.nama_urusan
    json.tujuan_opd tujuan_opd.tujuan
    json.tahun_awal tujuan_opd.tahun_awal
    json.tahun_akhir tujuan_opd.tahun_akhir
    json.indikator_tujuan tujuan_opd.targets do |target|
      json.indikator target.indikator.indikator
      json.tahun target.tahun
      json.target target.target
      json.satuan target.satuan
    end
  end
end
