json.id pohon.id
json.parent pohon.pohon_ref_id
json.strategi pohon.pohonable.strategi
json.keterangan pohon.keterangan
json.kode_perangkat_daerah pohon.pohonable.opd.kode_opd
json.perangkat_daerah pohon.pohonable.opd.nama_opd
json.indikators pohon.pohonable.indikators do |indikator|
  json.indikator indikator.indikator
  json.target indikator.target
  json.satuan indikator.satuan
end
