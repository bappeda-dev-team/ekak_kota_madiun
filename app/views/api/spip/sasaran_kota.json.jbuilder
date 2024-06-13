json.message 'Sasaran Pemda'
json.tahun @tahun
json.results @sasaran_kota do |sasaran|
  json.id sasaran.pohonable_id
  json.sasaran_kota sasaran.pohonable.sasaran_kotum.sasaran
  json.indikators sasaran.pohonable.indikators.each do |indikator|
    json.indikator indikator.to_s
    json.target indikator.target
    json.satuan indikator.satuan
  end
end
