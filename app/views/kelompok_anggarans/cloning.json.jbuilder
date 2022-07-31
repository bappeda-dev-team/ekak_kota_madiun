json.results @kelompok_anggarans.each do |kelompok_anggaran|
  json.id kelompok_anggaran.id
  json.text kelompok_anggaran.tahun_kelompok
end
