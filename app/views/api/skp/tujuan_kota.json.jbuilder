json.message "Tujuan Kota - KAK"
json.data do
  json.tahun @tahun
  json.jumlah_tujuan @tujuan_kota.size
  json.tujuan_kota_collections @tujuan_kota do |tujuan|
    json.id tujuan.id
    json.tujuan_kota tujuan.tujuan
    json.tahun_awal tujuan.tahun_awal
    json.tahun_akhir tujuan.tahun_akhir
    json.periode tujuan.tahun_awal_akhir
    json.indikators tujuan.indikator_tujuans do |indikator|
      json.indikator indikator.to_s
      json.rumus_perhitungan indikator.rumus_perhitungan
      json.sumber_data indikator.sumber_data
      json.target_indikators @range do |tahun|
        target = indikator.targets.find_by(tahun: tahun)
        json.tahun tahun
        json.target target&.target
        json.satuan target&.satuan
      end
    end
  end
end
