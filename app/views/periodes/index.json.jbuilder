json.results @periodes do |periode|
  json.id periode.id
  json.text "#{periode.tahun_awal}-#{periode.tahun_akhir} (#{periode.jenis_periode})"
  json.tahun_awal periode.tahun_awal
  json.tahun_akhir periode.tahun_akhir
end
