json.results @kelompok_anggarans.each do |kelompok_anggaran|
  json.id kelompok_anggaran.kode_tahun_sasaran
  json.text "#{kelompok_anggaran.tahun} #{kelompok_anggaran.kelompok[0] if kelompok_anggaran.kelompok == 'Perubahan'}"
end
