json.message "Sasaran Kota - KAK"
json.data do
  json.tahun @tahun
  json.jumlah_sasaran @sasaran_kota.size
  json.sasaran_kota_collections @sasaran_kota do |sasaran|
    json.id sasaran.id
    json.tujuan_kota sasaran.sasaran_kotum.tujuan_kota.to_s
    json.strategi_kota sasaran.to_s
    json.sasaran sasaran.sasaran_kotum.to_s
    json.indikators sasaran.indikators do |indikator|
      json.indikator indikator.to_s
      json.target indikator.target
      json.satuan indikator.satuan
    end
  end
end
