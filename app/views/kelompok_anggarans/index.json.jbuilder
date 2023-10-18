json.results @kelompok_anggarans.each do |kelompok_anggaran|
  json.id kelompok_anggaran.kode_tahun_sasaran
  json.text "#{kelompok_anggaran.nama_sederhana_kelompok_tahun}"
end
