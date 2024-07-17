json.id tema.id
json.parent tema.pohon_ref_id
json.tema tema.pohonable.tema
json.keterangan tema.keterangan
json.indikators tema.pohonable.indikators do |indikator|
    json.indikator indikator.indikator
    json.target indikator.target
    json.satuan indikator.satuan
end
