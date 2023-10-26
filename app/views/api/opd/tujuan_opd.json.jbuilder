json.message "Data Tujuan OPD - KAK"
json.description "Data Tujuan OPD 5 Tahunan"
json.data do
  json.kode_opd @opd.kode_unik_opd
  json.nama_opd @opd.nama_opd
  json.tujuan_opd @tujuan_opds do |tujuan|
    json.tujuan tujuan.tujuan
    json.indikator_tujuan tujuan.indikators do |indikator|
      json.indikator indikator.indikator || '-'
      json.rumus_perhitungan indikator.rumus_perhitungan || '-'
      json.sumber_data indikator.sumber_data || '-'
      json.targets indikator.targets do |target|
        json.tahun target.tahun
        json.target target
        json.satuan target&.satuan
      end
    end
  end
end
