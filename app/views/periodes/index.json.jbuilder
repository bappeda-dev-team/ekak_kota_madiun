json.results @periodes do |periode|
  json.id periode.id
  json.text "#{periode.tahun_awal}-#{periode.tahun_akhir}"
end
