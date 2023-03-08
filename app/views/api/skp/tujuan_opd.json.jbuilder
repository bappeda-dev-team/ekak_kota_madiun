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
    tahun_range = (2020..2024).to_a
    json.indikator_tujuan tujuan_opd.indikator_tujuans[:indikator_tujuan] do |indikator, values|
      json.array! tahun_range do |tahun|
        targets = values[tahun.to_s]
        json.indikator indikator
        json.tahun tahun
        json.target targets&.last.target
        json.satuan targets&.last.satuan
      end
    end
  end
end
