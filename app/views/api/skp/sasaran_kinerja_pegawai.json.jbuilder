json.nip @nip
json.sasaran_asn @sasarans do |sasaran|
  json.sasaran sasaran.sasaran_kinerja
  json.indikator_sasaran sasaran.indikator_sasarans do |indikator_sasaran|
    json.indikator indikator_sasaran.indikator
    json.target indikator_sasaran.target
    json.satuan indikator_sasaran.satuan
  end
  json.rencana_aksi sasaran.tahapans do |renaksi|
    json.tahapan renaksi.tahapan
  end
end
