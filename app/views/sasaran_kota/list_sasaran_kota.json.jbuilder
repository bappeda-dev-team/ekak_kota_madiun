json.results @sasaran_kota do |sasaran|
  json.id sasaran[:id]
  json.text sasaran[:sasaran]
  json.iku sasaran[:indikators] do |indikator|
    json.indikator indikator.to_s
    json.target indikator.target
    json.satuan indikator.satuan
  end
  json.dinas sasaran[:dinas]
end
