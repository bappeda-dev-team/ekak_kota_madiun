json.message 'Akar Masalah EKAK'
json.tahun @tahun
json.kode_opd @kode_opd
json.nama_opd @opd.nama_opd
json.masalah_pokoks @strategi_opds.each do |strategi|
  json.id_masalah_pokok strategi.id
  json.parent_masalah ''
  json.jenis 'MasalahPokok'
  json.masalah_pokok strategi.masalah
  json.masalahs strategi.strategi_bawahans do |tactical|
    json.id_masalah tactical.id
    json.parent_masalah strategi.id
    json.jenis 'Masalah'
    json.masalah tactical.masalah
    json.akar_masalahs tactical.strategi_bawahans do |operational|
      json.id_masalah operational.id
      json.parent_masalah tactical.id
      json.jenis 'AkarMasalah'
      json.akar_masalah operational.masalah
    end
  end
end
